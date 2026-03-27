<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $notifications = $request->user()
            ->notifications()
            ->latest()
            ->paginate(15);

        return response()->json($notifications);
    }

    public function markAsRead($id)
    {
        $notification = Notification::findOrFail($id);

        if ($notification->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        $notification->update(['is_read' => true]);

        return response()->json($notification);
    }

    public function markAllAsRead(Request $request)
    {
        $request->user()
            ->notifications()
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json(['message' => 'All notifications marked as read.']);
    }

    /**
     * Staff sends a notification to a customer (with optional image & location).
     */
    public function send(Request $request)
    {
        $request->validate([
            'customer_id'  => 'required|exists:users,id',
            'message_en'   => 'required|string|max:500',
            'message_ku'   => 'required|string|max:500',
            'location'     => 'nullable|string|max:255',
            'image'        => 'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
            'shipment_id'  => 'nullable|exists:shipments,id',
        ]);

        // Only staff / super_admin can send
        $sender = $request->user();
        if (!in_array($sender->role, ['staff', 'super_admin'])) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        // Handle image upload
        $imageUrl = null;
        if ($request->hasFile('image')) {
            $path     = $request->file('image')->store('notifications', 'public');
            $imageUrl = Storage::url($path);
        }

        $notification = Notification::create([
            'user_id'    => $request->customer_id,
            'message_en' => $request->message_en,
            'message_ku' => $request->message_ku,
            'type'       => 'status_update',
            'location'   => $request->location,
            'image_url'  => $imageUrl,
            'is_read'    => false,
        ]);

        return response()->json($notification, 201);
    }

    /**
     * List all customers (for the staff picker).
     */
    public function customers()
    {
        $sender = auth()->user();
        if (!in_array($sender->role, ['staff', 'super_admin'])) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $customers = User::where('role', 'customer')
            ->select('id', 'name', 'email')
            ->orderBy('name')
            ->get();

        return response()->json($customers);
    }

    /**
     * Staff views all notifications they have sent.
     */
    public function sent(Request $request)
    {
        $sender = $request->user();
        if (!in_array($sender->role, ['staff', 'super_admin'])) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $notifications = Notification::with('user:id,name,email')
            ->where('type', 'status_update')
            ->latest()
            ->paginate(20);

        return response()->json($notifications);
    }
}
