<?php

namespace App\Http\Controllers\Quran\Reciter;

use App\Concerns\FileHandler;
use App\Http\Controllers\Controller;
use App\Http\Requests\Quran\Reciter\ReciterSuraRequest;
use App\Jobs\Sura\SuraUploadJob;
use App\Models\Quran\Reciter\Reciter;
use App\Models\Quran\Reciter\ReciterSura;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class ReciterSuraController extends Controller
{
    use FileHandler;

    public function index(Reciter $reciter)
    {
        $search = request('search');
        return ReciterSura::query()
            ->where('reciter_id', $reciter->id)
            ->when($search, function ($query) use ($search) {
                $query->where('name', 'like', '%' . $search . '%');
                $query->orWhere('number', 'like', '%' . $search . '%');
                $query->orWhere('revealed_place', 'like', '%' . $search . '%');
            })
            ->orderBy('number', 'ASC')
            ->paginate(10);
    }


    public function uploadChunk(Request $request)
    {
        $validatedData = $request->validate([
            'chunkNumber' => ['required', 'integer'],
            'totalChunks' => ['required', 'integer'],
            'fileName' => ['required', 'string'],
            'reciterName' => ['required', 'string'], // Add reciter name to identify the file
        ]);

        $uploadedFile = $request->file('file');

        if (!$uploadedFile || !$uploadedFile->isValid()) {
            return response()->json(['status' => false, 'message' => 'Invalid file or file not uploaded correctly'], 400);
        }

        $reciterName = $validatedData['reciterName'];  // Get the reciter's name from the request
        $tempDir = storage_path("app/temp_uploads/{$reciterName}");  // Create a directory for each reciter

        if (!file_exists($tempDir)) {
            mkdir($tempDir, 0755, true);
        }

        try {
            // Save each chunk as a part of the final file
            $filePath = "{$tempDir}/{$validatedData['fileName']}.part{$validatedData['chunkNumber']}";
            file_put_contents($filePath, file_get_contents($uploadedFile->getRealPath()));
            \Log::info("Saved chunk {$validatedData['chunkNumber']} successfully for reciter: {$reciterName}");

            // Check if it's the last chunk, then merge them
            if ($validatedData['chunkNumber'] == $validatedData['totalChunks']) {
                $this->mergeChunks($tempDir, $validatedData['fileName'], $reciterName);
                return response()->json(['status' => 'completed', 'filePath' => $this->getFinalFilePath($reciterName, $validatedData['fileName'])]);
            }

            return response()->json(['status' => 'chunk_uploaded']);
        } catch (\Exception $e) {
            \Log::error("Error while uploading chunk for reciter {$reciterName}: " . $e->getMessage());
            return response()->json(['status' => 'error', 'message' => 'Error while uploading chunk'], 500);
        }
    }

    private function mergeChunks($tempDir, $finalFileName, $reciterName)
    {
        try {
            // Define the directory and ensure it exists
            $destinationDir = storage_path("app/public/quran/{$reciterName}");
            if (!file_exists($destinationDir)) {
                mkdir($destinationDir, 0755, true); // Ensure the directory is created
            }

            // The final path where the complete file will be saved
            $finalFilePath = "{$destinationDir}/{$finalFileName}.mp3";  // Use reciter's name for the file

            $chunks = [];
            for ($i = 1; $i <= $this->getTotalChunks(); $i++) {
                $chunkPath = "{$tempDir}/{$finalFileName}.part{$i}";
                if (file_exists($chunkPath) && is_readable($chunkPath)) {
                    $chunks[] = fopen($chunkPath, 'r');
                } else {
                    \Log::warning("Chunk {$i} not found or not readable: {$chunkPath}");
                    continue;
                }
            }

            if (empty($chunks)) {
                throw new \Exception("All chunks were missing or unreadable.");
            }

            // Merge the chunks into the final file
            $mergedStream = fopen($finalFilePath, 'w+');
            foreach ($chunks as $chunk) {
                fwrite($mergedStream, stream_get_contents($chunk));
                fclose($chunk);
            }
            fclose($mergedStream);

            // Remove the temp directory and its contents
            $this->removeDirectory($tempDir);

            \Log::info("File for reciter {$reciterName} merged and stored successfully: {$finalFilePath}");

            // Return the relative path of the file
            return response()->json([
                'status' => true,
                'message' => 'File merged and stored successfully',
                'filePath' => "/storage/quran/{$reciterName}/{$finalFileName}.mp3"  // Return the relative file path
            ]);
        } catch (\Exception $exception) {
            \Log::error("Error merging chunks for reciter {$reciterName}: " . $exception->getMessage());
            return response()->json([
                'status' => false,
                'message' => 'Error merging chunks'
            ], 500);
        }
    }


    private function removeDirectory($directory)
    {
        if (!is_dir($directory)) {
            return;
        }

        if (($dir = opendir($directory)) !== false) {
            while (false !== ($entry = readdir($dir))) {
                $path = $directory . DIRECTORY_SEPARATOR . $entry;
                if ($entry != "." && $entry != "..") {
                    $isDir = is_dir($path);
                    if ($isDir) {
                        $this->removeDirectory($path);
                    } else {
                        unlink($path);
                    }
                }
            }
            closedir($dir);
        }
        rmdir($directory);
    }

    private function getTotalChunks()
    {
        return request()->get('totalChunks');
    }

    private function getFinalFilePath($reciterName, $fileName)
    {
        // This function now returns the relative file path in the public directory
        return "/storage/quran/{$reciterName}/{$fileName}.mp3";
    }

    public function store(ReciterSuraRequest $request)
    {
        try {
            DB::beginTransaction();

            $checkIfAlreadyExist = ReciterSura::query()
                ->where('reciter_id', $request->reciter_id)
                ->where('number', $request->number)
                ->first();

            if ($checkIfAlreadyExist) {
                return response()->json([
                    'status' => false,
                    'message' => 'Already Exists',
                    'data' => []
                ], 500);
            }

            $reciter = Reciter::query()->find($request->reciter_id);

            $sura = new ReciterSura([
                'reciter_id' => $request->reciter_id,
                'name' => $request->name,
                'number' => $request->number,
                'duration' => $request->duration,
                'revealed_place' => $request->revealed_place,
            ]);

            $suraNameNumber = strtolower(str_replace(' ', '_', $request->name)) . '_' . $request->number;
            $reciterName = strtolower(str_replace(' ', '_', $reciter->name));

            if ($request->hasFile('audio_file')) {
                $sura->path = $this->storeAudio($request->file('audio_file'), "quran/reciter-audio-sura/{$reciterName}", $suraNameNumber);
            } else {
                $sura->path = $request->audio_file;
            }

            $sura->save();

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Sura added successfully',
                'data' => []
            ]);
        } catch (\Exception $exception) {
            DB::rollback();
            return response()->json([
                'status' => false,
                'message' => $exception->getMessage(),
                'data' => []
            ],500);
        }
    }


    public function show(ReciterSura $reciterSura)
    {
        return $reciterSura;
    }

    public function update(ReciterSuraRequest $request, ReciterSura $reciterSura)
    {
        if ($request->id != $reciterSura->id) {
            return response()->json([
                'status' => false,
                'message' => 'It\'s not possible to edit other records',
            ]);
        }

        $reciterSura->name = $request->name;
        $reciterSura->number = $request->number;
        $reciterSura->revealed_place = $request->revealed_place;

        $suraNameNumber = strtolower(str_replace(' ', '_', $request->name)) . '_' . $request->number;
        $reciterName = strtolower(str_replace(' ', '_', $reciterSura->reciter->name));

        if ($request->hasFile('audio_file')) {
            $reciterSura->path = $this->storeAudio($request->file('audio_file'), "quran/reciter-audio-sura/{$reciterName}", $suraNameNumber);
        } else {
            $reciterSura->path = $request->audio_file;
        }

        $reciterSura->save();

        return response()->json([
            'status' => true,
            'message' => 'Sura updated successfully',
            'data' => []
        ]);

    }

    public function destroy(ReciterSura $reciterSura)
    {
        $reciterSura->delete();

        return response()->json([
            'status' => true,
            'message' => 'Sura deleted successfully',
            'data' => [],
        ]);
    }
}
