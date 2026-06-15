<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta name="author" content="{{config('settings.application.company_name')}}">
    <meta name="keywords" content="{{config('settings.application.company_name')}}">
    <link rel="shortcut icon" href="{{ asset(config('settings.application.app_icon')) }}"/>
    <title>{{config('settings.application.company_name')}} Terms Condition</title>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5 p-4 bg-white shadow rounded">

    <!-- Company Logo -->
    <div class="text-center mb-4">
        <img src="{{asset(config('settings.application.web_logo'))}}" alt="Company Logo" class="img-fluid"
             style="max-width: 100px;">
    </div>

    <section class="mb-2">
        {!! config('settings.application.terms_and_conditions') !!}
    </section>

    <a href="{{route('login')}}">Back to Login</a>

</div>
</body>
</html>
