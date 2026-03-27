<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\VehicleType;
use App\Models\PricingConfig;
use App\Models\User;
use App\Models\Faq;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    // User Management
    public function users()
    {
        return response()->json(User::paginate(15));
    }

    public function storeUser(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
            'role' => 'required|in:staff,driver,super_admin',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => \Illuminate\Support\Facades\Hash::make($request->password),
            'role' => $request->role,
        ]);

        return response()->json($user, 201);
    }

    public function toggleUserStatus($id)
    {
        $user = User::findOrFail($id);
        $user->update(['is_active' => !$user->is_active]);
        return response()->json($user);
    }

    // Categories
    public function categories()
    {
        return response()->json(Category::all());
    }

    public function storeCategory(Request $request)
    {
        $request->validate([
            'name_en' => 'required|string',
            'name_ku' => 'required|string',
            'surcharge' => 'required|numeric',
        ]);
        return response()->json(Category::create($request->all()), 201);
    }

    // Vehicle Types
    public function vehicleTypes()
    {
        return response()->json(VehicleType::all());
    }

    public function storeVehicleType(Request $request)
    {
        $request->validate([
            'name_en' => 'required|string',
            'name_ku' => 'required|string',
            'multiplier' => 'required|numeric',
            'delivery_days_offset' => 'required|integer',
        ]);
        return response()->json(VehicleType::create($request->all()), 201);
    }

    // Pricing Config
    public function pricing()
    {
        return response()->json(PricingConfig::first());
    }

    public function updatePricing(Request $request)
    {
        $request->validate([
            'base_price' => 'required|numeric',
            'weight_rate' => 'required|numeric',
        ]);
        $pricing = PricingConfig::first() ?? new PricingConfig();
        $pricing->fill($request->all())->save();
        return response()->json($pricing);
    }

    // FAQs
    public function faqs()
    {
        return response()->json(Faq::orderBy('sort_order')->get());
    }

    public function storeFaq(Request $request)
    {
        $request->validate([
            'question_en' => 'required|string',
            'question_ku' => 'required|string',
            'answer_en' => 'required|string',
            'answer_ku' => 'required|string',
            'sort_order' => 'integer',
        ]);
        return response()->json(Faq::create($request->all()), 201);
    }
}
