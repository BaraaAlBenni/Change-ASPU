<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\api\UserApiController;
use App\Http\Controllers\api\CategoryController;
use App\Http\Controllers\api\VolunteerWorkController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});




Route::post('register',[UserApiController::class,'register']);
Route::post('login',[UserApiController::class,'login']);
Route::post('logout',[UserApiController::class,'logout'])->middleware('auth:sanctum');




Route::get('/categories_display', [CategoryController::class, 'index'])->middleware('auth:sanctum');
Route::post('/category_store', [CategoryController::class, 'store'])->middleware('auth:sanctum');
Route::put('/category_update/{id}', [CategoryController::class, 'update'])->middleware('auth:sanctum');
Route::delete('/category_delete/{id}', [CategoryController::class, 'destroy'])->middleware('auth:sanctum');



Route::get('/Volunteer_display', [VolunteerWorkController::class, 'index']);
Route::post('/Volunteer_store', [VolunteerWorkController::class, 'store'])->middleware('auth:sanctum');
Route::put('/Volunteer_update/{id}', [VolunteerWorkController::class, 'update'])->middleware('auth:sanctum');
Route::delete('/Volunteer_delete/{id}', [VolunteerWorkController::class, 'destroy'])->middleware('auth:sanctum');


Route::get('volunteer-works/search', [VolunteerWorkController::class, 'search']);
