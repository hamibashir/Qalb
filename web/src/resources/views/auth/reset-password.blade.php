@extends('layouts.auth.auth_master')
@section('title','Reset Password')
@section('content')
    <div class="d-table-cell align-middle">
        <app-reset-password token="{{json_encode($token)}}"></app-reset-password>
    </div>
@endsection
