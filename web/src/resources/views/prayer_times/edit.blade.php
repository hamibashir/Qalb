@extends('layouts.app')
@section('title', 'Edit Prayer Time')
@section('content')
    <app-prayer-create @if(isset($id)) selected-url="/prayer-times/{{$id}}" @endif></app-prayer-create>
@endsection
