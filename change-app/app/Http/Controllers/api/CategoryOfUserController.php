<?php

namespace App\Http\Controllers\api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\CategoryOfUser;
use Illuminate\Support\Facades\Validator;

class CategoryOfUserController extends Controller
{
    public function store(Request $request)
    {

        $user_id = Auth::id();

        $validator = Validator::make($request->all(), [
            'category_ids' => 'required|array',
            'category_ids.*' => 'exists:categories,id',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $category_ids = $request->input('category_ids');
        CategoryOfUser::where('user_id', $user_id)->delete();
        foreach ($category_ids as $category_id) {
            $categoryOfUser = new CategoryOfUser();
            $categoryOfUser->user_id = $user_id;
            $categoryOfUser->category_id = $category_id;
            $categoryOfUser->save();
        }

        return response()->json(['message' => 'Categories updated successfully'], 200);
    }
}
