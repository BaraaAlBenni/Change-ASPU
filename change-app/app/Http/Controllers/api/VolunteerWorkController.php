<?php

namespace App\Http\Controllers\api;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Volunteer_work;
use App\Models\Day_of_vlunteer;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Carbon;
class VolunteerWorkController extends Controller
{

    public function index()
    {
        $Volunteer = Volunteer_work::all();
        return response()->json($Volunteer, 200);
    }

   /* public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'description' => 'required|string|max:255',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'address' => 'sometimes|required|string|max:255',
            'point' => 'required|integer|min:1',
            'count_worker' => 'required|integer|min:1',
            'category_id' => 'required|exists:categories,id', // validate category_id from request
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        // use the authenticated user's id as the user_id for the new task
        $validatedData = $validator->validated();
        $validatedData['user_id'] = Auth::id();
        // create the Volunteer_work record
        $volunteerWork = Volunteer_work::create($validatedData);
        // get the start and end dates of the Volunteer_work record
        $startDate = $volunteerWork->start_date;
        $endDate = $volunteerWork->end_date;
        // get the day of the week for the start and end dates
        $startDayOfWeek = Carbon::parse($startDate)->dayOfWeek;
        $endDayOfWeek = Carbon::parse($endDate)->dayOfWeek;
        // create a new Day record for each day of the week between the start and end dates
        for ($dayOfWeek = $startDayOfWeek; $dayOfWeek <= $endDayOfWeek; $dayOfWeek++) {
            $day = new Day_of_vlunteer();
            $day->volunteer_work_id = $volunteerWork->id;
            $day->day_of_week = $dayOfWeek;
            $day->save();
        }
        return response()->json($volunteerWork, 201);
    }
   */
  public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'description' => 'required|string|max:255',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'address' => 'sometimes|required|string|max:255',
            'point' => 'required|integer|min:1',
            'count_worker' => 'required|integer|min:1',
            'category_id' => 'required|exists:categories,id', // validate category_id from request
            'days' => 'required|array',
            'days.*' => 'string|in:sunday,monday,tuesday,wednesday,thursday,friday,saturday',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        // use the authenticated user's id as the user_id for the new task
        $validatedData = $validator->validated();
        $validatedData['user_id'] = Auth::id();
        // create the Volunteer_work record
        $volunteerWork = Volunteer_work::create($validatedData);
        // get the days of the week from the request
        $days = $request->input('days');
        // create a new Day record for each day of the week requested
        foreach ($days as $day) {
            $dayRecord = new Day_of_vlunteer();
            $dayRecord->volunteer_work_id = $volunteerWork->id;
            $dayRecord->day_of_week = $day;
            $dayRecord->save();
        }
        return response()->json($volunteerWork, 201);
    }



    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'description' => 'sometimes|required|string|max:255',
            'address' => 'sometimes|required|string|max:255',
            'start_date' => 'sometimes|required|date',
            'end_date' => 'sometimes|required|date|after:start_date',
            'point' => 'sometimes|required|integer|min:1',
            'count_worker' => 'sometimes|required|integer|min:1',
            'category_id' => 'sometimes|required|exists:categories,id',
            'days' => 'sometimes|required|array',
            'days.*' => 'string|in:sunday,monday,tuesday,wednesday,thursday,friday,saturday',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        $validatedData = $validator->validated();
        $volunteerWork = Volunteer_work::findOrFail($id);
        $volunteerWork->update($validatedData);
        // get the days of the week from the request
        $days = $request->input('days');
        // delete all existing Day_of_vlunteer records associated with the Volunteer_work record
        Day_of_vlunteer::where('volunteer_work_id', $volunteerWork->id)->delete();
        // create a new Day_of_vlunteer record for each day of the week requested
        foreach ($days as $day) {
            $dayRecord = new Day_of_vlunteer();
            $dayRecord->volunteer_work_id = $volunteerWork->id;
            $dayRecord->day_of_week = $day;
            $dayRecord->save();
        }
        return response()->json($volunteerWork, 200);
    }

    public function destroy(Request $request, $id)
    {
        $volunteerWork = Volunteer_work::findOrFail($id);
        $volunteerWork->delete();
        return response()->json(null, 204);

    }



    public function search(Request $request)
    {
        $categoryId = $request->query('category_id');
        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');
        $userType = $request->query('user_type');
        $address = $request->query('address');

        $query = Volunteer_work::query();

        if ($categoryId) {
            $query->where('category_id', $categoryId);
        }
        /**{
         * 'category_id = 1
         * } */

        if ($startDate && $endDate) {
            $query->whereBetween('start_date', [$startDate, $endDate]);
        } elseif ($startDate) {
            $query->where('start_date', '>=', $startDate);
        } elseif ($endDate) {
            $query->where('start_date', '<=', $endDate);
            /**
             * {
             *      'start_date'=>"2024-5-7"
             *      'endDate'=>"2026-5-7"
             * }
             */
        } elseif ($userType) {
            $query->whereHas('User', function ($query) use ($userType) {
                $query->where('type_user', $userType);
            })->where('user_id', auth()->id());
            /**
             * {
             *      'user_id' => '0'
             * }
             */
        } elseif ($address) {

            $query->where('address', 'like', '%' . $address . '%');

        }


        $volunteerWorks = $query->get();

        return response()->json($volunteerWorks, 200);
    }
}
