-- ============ CONTRACTS ============
CREATE TABLE public.contracts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  description text NOT NULL,
  amount numeric NOT NULL DEFAULT 0,
  cycle text NOT NULL DEFAULT 'MONTHLY',
  billing_day integer NOT NULL DEFAULT 1,
  payment_method text NOT NULL DEFAULT 'UNDEFINED',
  start_date date NOT NULL DEFAULT current_date,
  end_date date,
  status text NOT NULL DEFAULT 'active',
  account_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  cost_center_id uuid REFERENCES public.cost_centers(id) ON DELETE SET NULL,
  asaas_customer_id text,
  asaas_subscription_id text,
  next_due_date date,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.contracts TO authenticated;
GRANT ALL ON public.contracts TO service_role;
ALTER TABLE public.contracts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "contracts_select" ON public.contracts FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "contracts_insert" ON public.contracts FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "contracts_update" ON public.contracts FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "contracts_delete" ON public.contracts FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_contracts_updated BEFORE UPDATE ON public.contracts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_contracts_company ON public.contracts(company_id);

-- receivables.contract_id passa a apontar para contracts
ALTER TABLE public.receivables
  ADD CONSTRAINT receivables_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE SET NULL;

-- ============ PRODUCTS ============
CREATE TABLE public.products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  type text NOT NULL DEFAULT 'product',
  sku text,
  barcode text,
  unit text NOT NULL DEFAULT 'un',
  sell_price numeric NOT NULL DEFAULT 0,
  cost_price numeric,
  ncm text,
  cclasstrib text,
  cfop text,
  tax_origin text,
  account_id uuid REFERENCES public.chart_of_accounts(id) ON DELETE SET NULL,
  track_stock boolean NOT NULL DEFAULT false,
  current_stock numeric DEFAULT 0,
  min_stock numeric,
  category text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.products TO authenticated;
GRANT ALL ON public.products TO service_role;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "products_select" ON public.products FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "products_insert" ON public.products FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "products_update" ON public.products FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "products_delete" ON public.products FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_products_updated BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_products_company ON public.products(company_id);

-- ============ WAREHOUSES ============
CREATE TABLE public.warehouses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  address text,
  is_default boolean NOT NULL DEFAULT false,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.warehouses TO authenticated;
GRANT ALL ON public.warehouses TO service_role;
ALTER TABLE public.warehouses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "warehouses_select" ON public.warehouses FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "warehouses_insert" ON public.warehouses FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "warehouses_update" ON public.warehouses FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "warehouses_delete" ON public.warehouses FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_warehouses_updated BEFORE UPDATE ON public.warehouses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_warehouses_company ON public.warehouses(company_id);

-- ============ STOCK MOVEMENTS ============
CREATE TABLE public.stock_movements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  warehouse_id uuid REFERENCES public.warehouses(id) ON DELETE SET NULL,
  type text NOT NULL,
  quantity numeric NOT NULL,
  unit_cost numeric,
  reference_type text,
  reference_id uuid,
  notes text,
  user_id uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.stock_movements TO authenticated;
GRANT ALL ON public.stock_movements TO service_role;
ALTER TABLE public.stock_movements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "stock_movements_select" ON public.stock_movements FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "stock_movements_insert" ON public.stock_movements FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "stock_movements_update" ON public.stock_movements FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "stock_movements_delete" ON public.stock_movements FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE INDEX idx_stock_mov_company ON public.stock_movements(company_id);
CREATE INDEX idx_stock_mov_product ON public.stock_movements(product_id);

-- ============ SALES ORDERS ============
CREATE TABLE public.sales_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  user_id uuid,
  order_number integer,
  status text NOT NULL DEFAULT 'quote',
  issue_date date NOT NULL DEFAULT current_date,
  due_date date,
  subtotal numeric NOT NULL DEFAULT 0,
  discount_value numeric NOT NULL DEFAULT 0,
  shipping numeric NOT NULL DEFAULT 0,
  total numeric NOT NULL DEFAULT 0,
  salesperson text,
  salesperson_id uuid,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.sales_orders TO authenticated;
GRANT ALL ON public.sales_orders TO service_role;
ALTER TABLE public.sales_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sales_orders_select" ON public.sales_orders FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "sales_orders_insert" ON public.sales_orders FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "sales_orders_update" ON public.sales_orders FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "sales_orders_delete" ON public.sales_orders FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_sales_orders_updated BEFORE UPDATE ON public.sales_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_sales_orders_company ON public.sales_orders(company_id);

CREATE TABLE public.sales_order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES public.sales_orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES public.products(id) ON DELETE SET NULL,
  description text NOT NULL DEFAULT '',
  quantity numeric NOT NULL DEFAULT 1,
  unit_price numeric NOT NULL DEFAULT 0,
  discount_percent numeric NOT NULL DEFAULT 0,
  total numeric NOT NULL DEFAULT 0,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.sales_order_items TO authenticated;
GRANT ALL ON public.sales_order_items TO service_role;
ALTER TABLE public.sales_order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "soi_select" ON public.sales_order_items FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.sales_orders o WHERE o.id = order_id AND public.is_company_member(o.company_id)));
CREATE POLICY "soi_insert" ON public.sales_order_items FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.sales_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)));
CREATE POLICY "soi_update" ON public.sales_order_items FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.sales_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)))
  WITH CHECK (EXISTS (SELECT 1 FROM public.sales_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)));
CREATE POLICY "soi_delete" ON public.sales_order_items FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.sales_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)));
CREATE INDEX idx_soi_order ON public.sales_order_items(order_id);

-- ============ PURCHASE ORDERS ============
CREATE TABLE public.purchase_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES public.contacts(id) ON DELETE SET NULL,
  user_id uuid,
  order_number integer,
  status text NOT NULL DEFAULT 'draft',
  issue_date date NOT NULL DEFAULT current_date,
  expected_date date,
  subtotal numeric NOT NULL DEFAULT 0,
  discount_value numeric NOT NULL DEFAULT 0,
  shipping numeric NOT NULL DEFAULT 0,
  total numeric NOT NULL DEFAULT 0,
  payment_terms text,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.purchase_orders TO authenticated;
GRANT ALL ON public.purchase_orders TO service_role;
ALTER TABLE public.purchase_orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "purchase_orders_select" ON public.purchase_orders FOR SELECT TO authenticated USING (public.is_company_member(company_id));
CREATE POLICY "purchase_orders_insert" ON public.purchase_orders FOR INSERT TO authenticated WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "purchase_orders_update" ON public.purchase_orders FOR UPDATE TO authenticated USING (public.can_write_company(company_id)) WITH CHECK (public.can_write_company(company_id));
CREATE POLICY "purchase_orders_delete" ON public.purchase_orders FOR DELETE TO authenticated USING (public.is_company_admin(company_id));
CREATE TRIGGER trg_purchase_orders_updated BEFORE UPDATE ON public.purchase_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_purchase_orders_company ON public.purchase_orders(company_id);

CREATE TABLE public.purchase_order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES public.purchase_orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES public.products(id) ON DELETE SET NULL,
  description text NOT NULL DEFAULT '',
  quantity numeric NOT NULL DEFAULT 1,
  unit_price numeric NOT NULL DEFAULT 0,
  total numeric NOT NULL DEFAULT 0,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.purchase_order_items TO authenticated;
GRANT ALL ON public.purchase_order_items TO service_role;
ALTER TABLE public.purchase_order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "poi_select" ON public.purchase_order_items FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.purchase_orders o WHERE o.id = order_id AND public.is_company_member(o.company_id)));
CREATE POLICY "poi_insert" ON public.purchase_order_items FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.purchase_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)));
CREATE POLICY "poi_update" ON public.purchase_order_items FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.purchase_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)))
  WITH CHECK (EXISTS (SELECT 1 FROM public.purchase_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)));
CREATE POLICY "poi_delete" ON public.purchase_order_items FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.purchase_orders o WHERE o.id = order_id AND public.can_write_company(o.company_id)));
CREATE INDEX idx_poi_order ON public.purchase_order_items(order_id);