@extends('layouts.app')
@section('title','Sura List')
@section('content')
    <app-audio-sura :reciter="{{ json_encode($reciter) }}"></app-audio-sura>
@endsection
