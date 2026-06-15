<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <style>
        /* Add your custom styles here */
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            line-height: 1.6;
            color: #333;
        }

        .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        header {
            background-color: #0A3D34;
            color: #ffffff;
            padding: 20px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            text-align: center;
        }

        h1 {
            margin: 0;
            font-size: 28px;
        }

        .content {
            padding: 20px;
        }

        p {
            margin: 0 0 15px;
            font-size: 16px;
            color: #555;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #0A3D34;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #0A3D34;
        }

        footer {
            text-align: center;
            padding: 20px;
            background-color: #f9f9f9;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
        }

        footer p {
            margin: 0;
            color: #777;
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <img src="{{ asset(config('settings.application.web_logo')) }}" alt="Logo">
        <h3>{{ config('settings.application.company_name') }} Reset Password Link</h3>
    </header>

    <div class="content">
        <p>Hello {{ $user->full_name }},</p>
        <p>You recently requested to reset your password for your account. Click the button below to reset it:</p>
        <a href="{{ $resetLink }}" class="btn">Reset Password</a>

        <p>If you did not request a password reset, please ignore this email or contact support if you have any
            concerns.</p>
    </div>

    <footer style="text-align: center;">
        <p>Thank you</p>
        <p>{{ config('settings.application.company_name') }}</p>
    </footer>
</div>
</body>
</html>
