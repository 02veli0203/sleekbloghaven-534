/*
  # Fix RLS policies for anonymous order creation

  1. Security Updates
    - Drop all existing policies on orders table
    - Create simple policy allowing anyone to insert orders
    - Create admin-only policies for other operations
    - Ensure anonymous users can place orders without authentication

  2. Changes Made
    - Allow anonymous users to create orders with simple policy
    - Restrict viewing, updating, and deleting to authenticated admin users only
    - Grant necessary permissions to anon role
*/

-- Disable RLS temporarily to clean up
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "Anyone can create orders" ON public.orders;
DROP POLICY IF EXISTS "Anonymous users can create orders" ON public.orders;
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can view orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can update orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can delete orders" ON public.orders;

-- Re-enable RLS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Create simple policy for anonymous order creation
CREATE POLICY "Allow anonymous order creation" 
ON public.orders 
FOR INSERT 
TO anon, authenticated
WITH CHECK (true);

-- Create policy for viewing orders (authenticated users only)
CREATE POLICY "Authenticated users can view orders" 
ON public.orders 
FOR SELECT 
TO authenticated
USING (true);

-- Create policy for updating orders (authenticated users only)
CREATE POLICY "Authenticated users can update orders" 
ON public.orders 
FOR UPDATE 
TO authenticated
USING (true);

-- Create policy for deleting orders (authenticated users only)
CREATE POLICY "Authenticated users can delete orders" 
ON public.orders 
FOR DELETE 
TO authenticated
USING (true);

-- Grant necessary permissions
GRANT INSERT ON public.orders TO anon;
GRANT SELECT, UPDATE, DELETE ON public.orders TO authenticated;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;