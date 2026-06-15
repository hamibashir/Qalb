<?php

namespace App\Services\Installer;

use App\Exceptions\GeneralException;
use App\Helpers\Installer\DatabaseManagerHelper;
use App\Models\User;
use App\Services\BaseService;
use Illuminate\Support\Facades\Artisan;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;

class DatabaseManagerService extends BaseService
{
    protected DatabaseManagerHelper $databaseManager;

    public function __construct(DatabaseManagerHelper $databaseManager)
    {
        $this->databaseManager = $databaseManager;

    }

    public function clearCaches(): self
    {
        Artisan::call('config:clear');
        Artisan::call('route:clear');
        Artisan::call('view:clear');

        return $this;
    }


    /**
     * @throws ContainerExceptionInterface
     * @throws NotFoundExceptionInterface
     * @throws GeneralException
     */
    public function setDatabaseConnection(): self
    {
        $this->databaseManager->setDatabaseConfig();

        return $this;
    }

    public function saveFileWizard(): self
    {
        $this->databaseManager->saveFileWizard(request());

        return $this;
    }

    public function sessionDestroy(): DatabaseManagerService
    {
        session()->flush();
        return $this;
    }

    public function setMigration(): self
    {
        $this->databaseManager->migration();

        return $this;
    }

    public function setDatabaseSeeder(): self
    {
        $this->databaseManager->seed();

        return $this;
    }

    public function storageLink(): self
    {
        $target = storage_path("app/public");
        $explode_base_path = explode(DIRECTORY_SEPARATOR, base_path());
        array_pop($explode_base_path);
        $explode_base_path[] = 'storage';
        $path = implode(DIRECTORY_SEPARATOR, $explode_base_path);
        if (!is_dir('storage')) {
            symlink($target, $path);
        }
        return $this;
    }

    public function updateUser(): static
    {
        $user = User::query()->first();
        $user->update([
            'first_name' => request()->get('first_name'),
            'last_name' => request()->get('last_name'),
            'email' => request()->get('email'),
            'password' => request()->get('password'),
        ]);

        return $this;

    }


    public function setEnvironmentValue(): DatabaseManagerService
    {
        $this->databaseManager->setEnvironmentValue('APP_INSTALLED', 'true');

        return $this;
    }

    public function setEnvironmentAppDebugValue(): DatabaseManagerService
    {
        $this->databaseManager->setEnvironmentValueSet('APP_DEBUG', 'false');

        return $this;
    }
}
