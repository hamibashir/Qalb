@extends('layouts.auth.auth_master')
@section('title','Join User')
@section('content')
    <div class="d-table-cell align-middle">
        <app-join-user user="{{json_encode($user)}}"></app-join-user>
    </div>
@endsection

