/*
  # Fix RLS policy for anonymous order creation

  1. Security Updates
    - Drop existing restrictive policies on orders table
    - Create new policy allowing anonymous users to insert orders
    - Maintain admin-only access for viewing, updating, and deleting orders
    - Ensure customers can place orders without authentication

  2. Changes Made
    - Allow anonymous (non-authenticated) users to create orders
    - Keep admin-only policies for order management
    - Maintain data security while enabling customer orders
*/

-- Drop existing policies that might be conflicting
DROP POLICY IF EXISTS "Anyone can create orders" ON public.orders;
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can view orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can update orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can delete orders" ON public.orders;

-- Create new policy allowing anonymous users to insert orders
CREATE POLICY "Anonymous users can create orders" 
ON public.orders 
FOR INSERT 
WITH CHECK (true);

-- Only admins can view orders
CREATE POLICY "Only admins can view orders" 
ON public.orders 
FOR SELECT 
USING (
  CASE 
    WHEN auth.uid() IS NULL THEN false
    ELSE is_admin(auth.uid())
  END
);

-- Only admins can update orders
CREATE POLICY "Only admins can update orders" 
ON public.orders 
FOR UPDATE 
USING (
  CASE 
    WHEN auth.uid() IS NULL THEN false
    ELSE is_admin(auth.uid())
  END
);

-- Only admins can delete orders
CREATE POLICY "Only admins can delete orders" 
ON public.orders 
FOR DELETE 
USING (
  CASE 
    WHEN auth.uid() IS NULL THEN false
    ELSE is_admin(auth.uid())
  END
);

-- Ensure the anon role has the necessary permissions
GRANT INSERT ON public.orders TO anon;
GRANT USAGE ON SCHEMA public TO anon;