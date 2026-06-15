<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta property="og:title" content="{{config('settings.application.company_name')}}">
    <meta property="og:description" content="{{config('settings.application.company_name')}} Admin Panel">
    <meta property="og:image" content="{{config('settings.application.web_logo')}}">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta property="og:url" content="{{ env('APP_URL') }}">
    <meta property="og:type" content="website">

    <link rel="apple-touch-icon" href="{{config('settings.application.web_icon')}}"/>
    <link rel="apple-touch-icon-precomposed" href="{{config('settings.application.web_icon')}}"/>

    <meta name="description" content="{{config('settings.application.company_name')}} Admin Panel">
    <meta name="author" content="{{config('settings.application.company_name')}}">
    <meta name="keywords" content="{{config('settings.application.company_name')}}">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="base-url" content="{{ url('/') }}">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="{{config('settings.application.web_icon')}}"/>
    <title>{{config('settings.application.company_name')}} | @yield('title')</title>
    <link href="{{asset('assets/css/app.css')}}" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        /* Add these styles to your existing stylesheet or create a new one */
        .card {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .form-control-lg {
            border-radius: 8px;
            transition: border-color 0.3s ease-in-out;
        }

        .form-control-lg:focus {
            border-color: #5a67d8; /* Change to your preferred color */
        }

        .btn-primary {
            background-color: #5a67d8; /* Change to your preferred color */
            border-radius: 8px;
            transition: background-color 0.3s ease-in-out;
        }

        .btn-primary:hover {
            background-color: #4854a3; /* Change to a slightly darker shade */
        }

        .card {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .form-control-lg {
            border-radius: 8px;
            transition: border-color 0.3s ease-in-out;
        }

        .form-control-lg:focus {
            border-color: #5a67d8; /* Change to your preferred color */
        }

        .btn-primary {
            background-color: #5a67d8; /* Change to your preferred color */
            border-radius: 8px;
            transition: background-color 0.3s ease-in-out;
        }

        .btn-primary:hover {
            background-color: #4854a3; /* Change to a slightly darker shade */
        }

        .forget-password-link {
            color: #5a67d8; /* Change to your preferred color */
        }

        .forget-password-link:hover {
            text-decoration: underline;
        }

        .copyright {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 12px;
            color: #888;
        }

        @yield('css')
    </style>
</head>
<body>

<main class="d-flex w-100" id="app">
    <div class="container d-flex flex-column">
        <div class="row vh-100">
            <div class="col-sm-10 col-md-8 col-lg-6 col-xl-5 mx-auto d-table h-100">
                @yield('content')
            </div>
        </div>
    </div>
</main>
@vite('resources/js/app.js')
<script src="{{asset('assets/js/app.js')}}"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

@yield('script')
<script>
    window.localStorage.setItem('company_name', "{{ config('settings.application.company_name') }}")
    window.localStorage.setItem('company_logo', "{{ config('settings.application.web_logo') }}")
</script>
</body>
</html>
