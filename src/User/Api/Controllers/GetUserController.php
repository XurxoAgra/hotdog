<?php

namespace App\User\Api\Controllers;

use Symfony\Component\HttpFoundation\Response;

class GetUserController
{
    public function __construct()
    {

    }

    public function __invoke()
    {
        return new Response(
            'This is the get user Controller',
            Response::HTTP_OK
        );
    }
}