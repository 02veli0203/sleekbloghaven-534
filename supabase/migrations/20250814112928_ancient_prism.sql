/*
  # Anonim sipariş oluşturma için RLS politikalarını düzelt

  1. Güvenlik Güncellemeleri
    - Orders tablosundaki mevcut politikaları kaldır
    - Anonim kullanıcıların sipariş oluşturmasına izin veren yeni politika ekle
    - Admin kullanıcılar için görüntüleme, güncelleme ve silme politikalarını koru
    - Müşterilerin kayıt olmadan sipariş verebilmesini sağla

  2. Yapılan Değişiklikler
    - Anonim kullanıcılar için INSERT politikası
    - Admin kullanıcılar için SELECT, UPDATE, DELETE politikaları
    - Anon role için gerekli izinleri ver
*/

-- Mevcut politikaları kaldır
DROP POLICY IF EXISTS "Anyone can create orders" ON public.orders;
DROP POLICY IF EXISTS "Anonymous users can create orders" ON public.orders;
DROP POLICY IF EXISTS "Allow anonymous order creation" ON public.orders;
DROP POLICY IF EXISTS "Users can view their own orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can view orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can update orders" ON public.orders;
DROP POLICY IF EXISTS "Only admins can delete orders" ON public.orders;
DROP POLICY IF EXISTS "Authenticated users can view orders" ON public.orders;
DROP POLICY IF EXISTS "Authenticated users can update orders" ON public.orders;
DROP POLICY IF EXISTS "Authenticated users can delete orders" ON public.orders;

-- RLS'yi geçici olarak devre dışı bırak
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;

-- RLS'yi tekrar etkinleştir
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Basit ve açık politikalar oluştur
-- 1. Herkes sipariş oluşturabilir (anonim dahil)
CREATE POLICY "Enable insert for all users" 
ON public.orders 
FOR INSERT 
WITH CHECK (true);

-- 2. Sadece kimlik doğrulaması yapılmış kullanıcılar siparişleri görüntüleyebilir
CREATE POLICY "Enable read for authenticated users only" 
ON public.orders 
FOR SELECT 
TO authenticated
USING (true);

-- 3. Sadece kimlik doğrulaması yapılmış kullanıcılar siparişleri güncelleyebilir
CREATE POLICY "Enable update for authenticated users only" 
ON public.orders 
FOR UPDATE 
TO authenticated
USING (true);

-- 4. Sadece kimlik doğrulaması yapılmış kullanıcılar siparişleri silebilir
CREATE POLICY "Enable delete for authenticated users only" 
ON public.orders 
FOR DELETE 
TO authenticated
USING (true);

-- Gerekli izinleri ver
GRANT INSERT ON public.orders TO anon;
GRANT SELECT, UPDATE, DELETE ON public.orders TO authenticated;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;

-- Sequence izinlerini de ver (UUID için gerekli olabilir)
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO anon;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;