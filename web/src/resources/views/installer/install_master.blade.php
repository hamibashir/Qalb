<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="{{ config('settings.application.company_name') }} Admin Panel">
    <meta name="author" content="{{ config('settings.application.company_name') }}}">
    <meta name="keywords" content="{{ config('settings.application.company_name') }}">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="{{ config('settings.application.web_icon') }}"/>
    <title>@yield('title')</title>

    <link href="{{asset('assets/css/app.css')}}" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>

<body>
<div class="container" id="app">
    @yield('content')
</div>
</main>

@vite('resources/js/app.js')

</body>

</html>
