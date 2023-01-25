<?php

namespace App\User\Api\Controllers;

use Symfony\Component\HttpFoundation\Response;

class CreateUserController
{
    public function __construct()
    {

    }

    public function __invoke()
    {
        return new Response(
            'This is the create user Controller',
            Response::HTTP_CREATED
        );
    }
}