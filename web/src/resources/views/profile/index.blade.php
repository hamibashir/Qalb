@extends('layouts.app')
@section('title','Profile')

@section('css')
    .img-circle {
    width: 80px !important;
    height: 80px !important;
    }

    .info-btn.active {
    background: #0A3D34 !important;
    color: #fff !important;
    }

    .info-btn:hover {
    background: #0A3D34;
    }

    .custom-image-upload-wrapper {
    position: relative;
    background-color: var(--base-color);
    }

    .custom-image-upload-wrapper,
    .custom-image-upload-wrapper .image-area {
    width: 90px;
    height: 90px;
    border-radius: 0.25rem;
    border: 1px solid #ced4da;
    }

    .custom-image-upload-wrapper .image-area img {
    width: auto !important;
    max-height: 65%;
    border-radius: 0.25rem;
    }

    .custom-image-upload-wrapper .input-area {
    position: absolute;
    right: 0;
    bottom: 0;
    left: 0;
    opacity: 0;
    padding: 5px 0;
    background-color: rgba(0, 0, 0, 0.4);
    border-bottom-left-radius: 0.25rem;
    border-bottom-right-radius: 0.25rem;
    transition: all 0.25s ease-in-out;
    }

    .custom-image-upload-wrapper .input-area #upload-label {
    width: 100%;
    font-size: 90%;
    cursor: pointer;
    margin-bottom: 0;
    text-align: center;
    color: #fff !important;
    }

    .custom-image-upload-wrapper:hover .input-area {
    opacity: 1;
    }

    .custom-image-upload-wrapper:hover {
    cursor: pointer;
    }

    .custom-image-upload-wrapper, .custom-image-upload-wrapper .image-area {
    width: 90px;
    height: 90px;
    border-radius: 0.25rem;
    border: 1px solid #ddd;
    }


    .custom-image-upload-wrapper, .custom-image-upload-wrapper .image-area {
    width: 90px;
    height: 90px;
    border-radius: 0.25rem;
    border: 1px solid #ddd;
    }

    .custom-image-upload-wrapper {
    position: relative;
    background-color: var(--base-color);
    }

    .custom-image-upload-wrapper .image-area img {
    width: auto !important;
    max-height: 65%;
    border-radius: 0.25rem;
    }

    .custom-image-upload-wrapper .input-area {
    position: absolute;
    right: 0;
    bottom: 0;
    left: 0;
    opacity: 0;
    padding: 5px 0;
    background-color: rgba(0, 0, 0, 0.4);
    border-bottom-left-radius: 0.25rem;
    border-bottom-right-radius: 0.25rem;
    transition: all 0.25s ease-in-out;
    }

    .custom-image-upload-wrapper .input-area #upload-label {
    width: 100%;
    font-size: 90%;
    cursor: pointer;
    margin-bottom: 0;
    text-align: center;
    color: #fff !important;
    }
@endsection

@section('content')
    <main class="content">
        <div class="container-fluid p-0">
            <div class="mb-4">
                <h1 class="h3 d-inline align-middle"><strong>Profile Information</strong></h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                <div class="card card-primary card-outline">
                    <div class="card-body box-profile">
                        <div class="text-center">
                            @php
                                $avatarUrl = asset('assets/img/avatar.png');
                                    if (@$user->profile->profile_picture){
                                        $avatarUrl = asset(@$user->profile->profile_picture);
                                    }
                            @endphp
                            <img class="profile-user-img img-fluid img-circle"
                                 src="{{ $avatarUrl }}"
                                 alt="User profile picture">
                        </div>
                        <h3 class="profile-username text-center">{{ auth()->user()->full_name }}</h3>
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="card">
                    <div class="card-body">
                        <div class="container">
                            <ul class="nav nav-tabs" id="myTabs">
                                <li class="nav-item">
                                    <a class="nav-link btn info-btn active" id="tab1" data-bs-toggle="tab"
                                       href="#personal">Personal</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link btn info-btn ml-5" id="tab2" data-bs-toggle="tab"
                                       href="#change-password">Change Password</a>
                                </li>
                            </ul>

                            <div class="tab-content mt-2">
                                <div class="tab-pane fade show active" id="personal">
                                    <div class="tab-content">
                                        <div class="tab-pane active" id="personal">
                                            <app-personal-info></app-personal-info>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="change-password">
                                    <app-password-change></app-password-change>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
@endsection
