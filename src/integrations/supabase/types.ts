export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.15"
  }
  public: {
    Tables: {
      agent_actions: {
        Row: {
          action_type: string
          agent: string
          amount: number | null
          company_id: string
          contact_name: string | null
          contact_whatsapp: string | null
          created_at: string
          decided_at: string | null
          decided_by: string | null
          dedupe_key: string | null
          description: string | null
          due_date: string | null
          executed_at: string | null
          id: string
          payload: Json
          status: string
          suggested_message: string | null
          title: string
          updated_at: string
        }
        Insert: {
          action_type: string
          agent: string
          amount?: number | null
          company_id: string
          contact_name?: string | null
          contact_whatsapp?: string | null
          created_at?: string
          decided_at?: string | null
          decided_by?: string | null
          dedupe_key?: string | null
          description?: string | null
          due_date?: string | null
          executed_at?: string | null
          id?: string
          payload?: Json
          status?: string
          suggested_message?: string | null
          title: string
          updated_at?: string
        }
        Update: {
          action_type?: string
          agent?: string
          amount?: number | null
          company_id?: string
          contact_name?: string | null
          contact_whatsapp?: string | null
          created_at?: string
          decided_at?: string | null
          decided_by?: string | null
          dedupe_key?: string | null
          description?: string | null
          due_date?: string | null
          executed_at?: string | null
          id?: string
          payload?: Json
          status?: string
          suggested_message?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "agent_actions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      agent_instances: {
        Row: {
          ativo: boolean
          canais: Json
          company_id: string
          config: Json
          created_at: string
          id: string
          last_result: Json | null
          last_run_at: string | null
          nome: string
          template_key: string
          updated_at: string
        }
        Insert: {
          ativo?: boolean
          canais?: Json
          company_id: string
          config?: Json
          created_at?: string
          id?: string
          last_result?: Json | null
          last_run_at?: string | null
          nome: string
          template_key: string
          updated_at?: string
        }
        Update: {
          ativo?: boolean
          canais?: Json
          company_id?: string
          config?: Json
          created_at?: string
          id?: string
          last_result?: Json | null
          last_run_at?: string | null
          nome?: string
          template_key?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "agent_instances_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      agent_rules: {
        Row: {
          agent: string
          ativo: boolean
          company_id: string
          config: Json
          created_at: string
          id: string
          updated_at: string
        }
        Insert: {
          agent: string
          ativo?: boolean
          company_id: string
          config?: Json
          created_at?: string
          id?: string
          updated_at?: string
        }
        Update: {
          agent?: string
          ativo?: boolean
          company_id?: string
          config?: Json
          created_at?: string
          id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "agent_rules_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_usage: {
        Row: {
          company_id: string | null
          completion_tokens: number
          created_at: string
          custo_centavos: number
          funcao: string
          id: string
          modelo: string | null
          prompt_tokens: number
          sucesso: boolean
        }
        Insert: {
          company_id?: string | null
          completion_tokens?: number
          created_at?: string
          custo_centavos?: number
          funcao: string
          id?: string
          modelo?: string | null
          prompt_tokens?: number
          sucesso?: boolean
        }
        Update: {
          company_id?: string | null
          completion_tokens?: number
          created_at?: string
          custo_centavos?: number
          funcao?: string
          id?: string
          modelo?: string | null
          prompt_tokens?: number
          sucesso?: boolean
        }
        Relationships: [
          {
            foreignKeyName: "ai_usage_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      bank_accounts: {
        Row: {
          account_number: string | null
          account_type: string
          active: boolean
          agency: string | null
          balance: number
          bank_code: string | null
          bank_name: string | null
          company_id: string
          created_at: string
          id: string
          last_synced_at: string | null
          name: string
          updated_at: string
        }
        Insert: {
          account_number?: string | null
          account_type?: string
          active?: boolean
          agency?: string | null
          balance?: number
          bank_code?: string | null
          bank_name?: string | null
          company_id: string
          created_at?: string
          id?: string
          last_synced_at?: string | null
          name: string
          updated_at?: string
        }
        Update: {
          account_number?: string | null
          account_type?: string
          active?: boolean
          agency?: string | null
          balance?: number
          bank_code?: string | null
          bank_name?: string | null
          company_id?: string
          created_at?: string
          id?: string
          last_synced_at?: string | null
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "bank_accounts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      bank_connections: {
        Row: {
          company_id: string
          consent_expires_at: string | null
          created_at: string
          external_id: string
          id: string
          institution_image: string | null
          institution_name: string | null
          last_synced_at: string | null
          provider: string
          status: string
          updated_at: string
        }
        Insert: {
          company_id: string
          consent_expires_at?: string | null
          created_at?: string
          external_id: string
          id?: string
          institution_image?: string | null
          institution_name?: string | null
          last_synced_at?: string | null
          provider?: string
          status?: string
          updated_at?: string
        }
        Update: {
          company_id?: string
          consent_expires_at?: string | null
          created_at?: string
          external_id?: string
          id?: string
          institution_image?: string | null
          institution_name?: string | null
          last_synced_at?: string | null
          provider?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "bank_connections_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      bank_transactions_raw: {
        Row: {
          account_external_id: string | null
          amount: number
          category: string | null
          company_id: string
          connection_id: string | null
          created_at: string
          date: string
          description: string
          direction: string
          external_id: string
          id: string
          payment_method: string | null
          provider: string
          raw: Json | null
          status: string
          transaction_id: string | null
          updated_at: string
        }
        Insert: {
          account_external_id?: string | null
          amount?: number
          category?: string | null
          company_id: string
          connection_id?: string | null
          created_at?: string
          date: string
          description?: string
          direction?: string
          external_id: string
          id?: string
          payment_method?: string | null
          provider?: string
          raw?: Json | null
          status?: string
          transaction_id?: string | null
          updated_at?: string
        }
        Update: {
          account_external_id?: string | null
          amount?: number
          category?: string | null
          company_id?: string
          connection_id?: string | null
          created_at?: string
          date?: string
          description?: string
          direction?: string
          external_id?: string
          id?: string
          payment_method?: string | null
          provider?: string
          raw?: Json | null
          status?: string
          transaction_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "bank_transactions_raw_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bank_transactions_raw_connection_id_fkey"
            columns: ["connection_id"]
            isOneToOne: false
            referencedRelation: "bank_connections"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bank_transactions_raw_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      bills_payable: {
        Row: {
          approval_status: string
          approved_at: string | null
          approved_by: string | null
          company_id: string
          contact_id: string | null
          created_at: string
          descricao: string | null
          fornecedor: string
          id: string
          is_recurring: boolean | null
          recurrence_group_id: string | null
          recurrence_index: number | null
          recurrence_total: number | null
          requested_by: string | null
          source: string
          status: string
          transaction_id: string | null
          updated_at: string
          valor: number
          vencimento: string
        }
        Insert: {
          approval_status?: string
          approved_at?: string | null
          approved_by?: string | null
          company_id: string
          contact_id?: string | null
          created_at?: string
          descricao?: string | null
          fornecedor: string
          id?: string
          is_recurring?: boolean | null
          recurrence_group_id?: string | null
          recurrence_index?: number | null
          recurrence_total?: number | null
          requested_by?: string | null
          source?: string
          status?: string
          transaction_id?: string | null
          updated_at?: string
          valor: number
          vencimento: string
        }
        Update: {
          approval_status?: string
          approved_at?: string | null
          approved_by?: string | null
          company_id?: string
          contact_id?: string | null
          created_at?: string
          descricao?: string | null
          fornecedor?: string
          id?: string
          is_recurring?: boolean | null
          recurrence_group_id?: string | null
          recurrence_index?: number | null
          recurrence_total?: number | null
          requested_by?: string | null
          source?: string
          status?: string
          transaction_id?: string | null
          updated_at?: string
          valor?: number
          vencimento?: string
        }
        Relationships: [
          {
            foreignKeyName: "bills_payable_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bills_payable_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bills_payable_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "bills_payable_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "bills_payable_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      budgets: {
        Row: {
          company_id: string
          created_at: string
          custos: number
          despesas: number
          id: string
          month: string
          notes: string | null
          receita: number
          updated_at: string
        }
        Insert: {
          company_id: string
          created_at?: string
          custos?: number
          despesas?: number
          id?: string
          month: string
          notes?: string | null
          receita?: number
          updated_at?: string
        }
        Update: {
          company_id?: string
          created_at?: string
          custos?: number
          despesas?: number
          id?: string
          month?: string
          notes?: string | null
          receita?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "budgets_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      cclasstrib_codigos: {
        Row: {
          ativo: boolean
          codigo: string
          created_at: string
          descricao: string
          tributo: string | null
          updated_at: string
        }
        Insert: {
          ativo?: boolean
          codigo: string
          created_at?: string
          descricao: string
          tributo?: string | null
          updated_at?: string
        }
        Update: {
          ativo?: boolean
          codigo?: string
          created_at?: string
          descricao?: string
          tributo?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      chart_of_accounts: {
        Row: {
          active: boolean
          code: string | null
          company_id: string
          created_at: string
          deducao: boolean
          editable: boolean
          group_code: string | null
          group_name: string | null
          id: string
          name: string
          parent_id: string | null
          type: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          code?: string | null
          company_id: string
          created_at?: string
          deducao?: boolean
          editable?: boolean
          group_code?: string | null
          group_name?: string | null
          id?: string
          name: string
          parent_id?: string | null
          type: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          code?: string | null
          company_id?: string
          created_at?: string
          deducao?: boolean
          editable?: boolean
          group_code?: string | null
          group_name?: string | null
          id?: string
          name?: string
          parent_id?: string | null
          type?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "chart_of_accounts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chart_of_accounts_parent_id_fkey"
            columns: ["parent_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chart_of_accounts_parent_id_fkey"
            columns: ["parent_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
        ]
      }
      classification_rules: {
        Row: {
          account_id: string | null
          acertos: number
          company_id: string
          cost_center_id: string | null
          created_at: string
          id: string
          padrao: string
          updated_at: string
        }
        Insert: {
          account_id?: string | null
          acertos?: number
          company_id: string
          cost_center_id?: string | null
          created_at?: string
          id?: string
          padrao: string
          updated_at?: string
        }
        Update: {
          account_id?: string | null
          acertos?: number
          company_id?: string
          cost_center_id?: string | null
          created_at?: string
          id?: string
          padrao?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "classification_rules_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classification_rules_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "classification_rules_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classification_rules_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "classification_rules_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
        ]
      }
      companies: {
        Row: {
          cclasstrib_padrao: string | null
          cnpj: string | null
          created_at: string
          id: string
          name: string
          onboarding_completed: boolean
          org_id: string | null
          plan_key: string
          regime_tributario: string | null
          updated_at: string
        }
        Insert: {
          cclasstrib_padrao?: string | null
          cnpj?: string | null
          created_at?: string
          id?: string
          name: string
          onboarding_completed?: boolean
          org_id?: string | null
          plan_key?: string
          regime_tributario?: string | null
          updated_at?: string
        }
        Update: {
          cclasstrib_padrao?: string | null
          cnpj?: string | null
          created_at?: string
          id?: string
          name?: string
          onboarding_completed?: boolean
          org_id?: string | null
          plan_key?: string
          regime_tributario?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      company_asaas_anticipations: {
        Row: {
          anticipated_value: number | null
          anticipation_date: string | null
          asaas_id: string
          company_id: string
          created_at: string
          credit_date: string | null
          debit_date: string | null
          denial_reason: string | null
          due_date: string | null
          fee: number | null
          id: string
          installment_count: number | null
          net_value: number | null
          payment_id: string | null
          raw_payload: Json | null
          status: string
          total_value: number | null
          updated_at: string
        }
        Insert: {
          anticipated_value?: number | null
          anticipation_date?: string | null
          asaas_id: string
          company_id: string
          created_at?: string
          credit_date?: string | null
          debit_date?: string | null
          denial_reason?: string | null
          due_date?: string | null
          fee?: number | null
          id?: string
          installment_count?: number | null
          net_value?: number | null
          payment_id?: string | null
          raw_payload?: Json | null
          status: string
          total_value?: number | null
          updated_at?: string
        }
        Update: {
          anticipated_value?: number | null
          anticipation_date?: string | null
          asaas_id?: string
          company_id?: string
          created_at?: string
          credit_date?: string | null
          debit_date?: string | null
          denial_reason?: string | null
          due_date?: string | null
          fee?: number | null
          id?: string
          installment_count?: number | null
          net_value?: number | null
          payment_id?: string | null
          raw_payload?: Json | null
          status?: string
          total_value?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_anticipations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_bills: {
        Row: {
          asaas_id: string
          can_be_cancelled: boolean | null
          company_id: string
          company_name: string | null
          created_at: string
          description: string | null
          due_date: string | null
          failure_reason: string | null
          fee: number | null
          id: string
          identification_field: string | null
          payment_date: string | null
          raw_payload: Json | null
          schedule_date: string | null
          status: string
          type: string | null
          updated_at: string
          value: number | null
        }
        Insert: {
          asaas_id: string
          can_be_cancelled?: boolean | null
          company_id: string
          company_name?: string | null
          created_at?: string
          description?: string | null
          due_date?: string | null
          failure_reason?: string | null
          fee?: number | null
          id?: string
          identification_field?: string | null
          payment_date?: string | null
          raw_payload?: Json | null
          schedule_date?: string | null
          status: string
          type?: string | null
          updated_at?: string
          value?: number | null
        }
        Update: {
          asaas_id?: string
          can_be_cancelled?: boolean | null
          company_id?: string
          company_name?: string | null
          created_at?: string
          description?: string | null
          due_date?: string | null
          failure_reason?: string | null
          fee?: number | null
          id?: string
          identification_field?: string | null
          payment_date?: string | null
          raw_payload?: Json | null
          schedule_date?: string | null
          status?: string
          type?: string | null
          updated_at?: string
          value?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_bills_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_config: {
        Row: {
          active: boolean
          api_key_production: string | null
          api_key_sandbox: string | null
          company_id: string
          created_at: string
          enabled_events: string[]
          environment: string
          id: string
          notification_email: string | null
          updated_at: string
          webhook_auth_token: string | null
          webhook_email: string | null
          webhook_id: string | null
          webhook_send_type: string | null
          webhook_status: string
          webhook_url: string | null
        }
        Insert: {
          active?: boolean
          api_key_production?: string | null
          api_key_sandbox?: string | null
          company_id: string
          created_at?: string
          enabled_events?: string[]
          environment?: string
          id?: string
          notification_email?: string | null
          updated_at?: string
          webhook_auth_token?: string | null
          webhook_email?: string | null
          webhook_id?: string | null
          webhook_send_type?: string | null
          webhook_status?: string
          webhook_url?: string | null
        }
        Update: {
          active?: boolean
          api_key_production?: string | null
          api_key_sandbox?: string | null
          company_id?: string
          created_at?: string
          enabled_events?: string[]
          environment?: string
          id?: string
          notification_email?: string | null
          updated_at?: string
          webhook_auth_token?: string | null
          webhook_email?: string | null
          webhook_id?: string | null
          webhook_send_type?: string | null
          webhook_status?: string
          webhook_url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: true
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_invoices: {
        Row: {
          asaas_id: string
          company_id: string
          created_at: string
          customer_id: string | null
          effective_date: string | null
          error_message: string | null
          id: string
          net_value: number | null
          number: string | null
          observations: string | null
          payment_id: string | null
          pdf_url: string | null
          service_description: string | null
          status: string
          taxes: Json | null
          updated_at: string
          value: number | null
          xml_url: string | null
        }
        Insert: {
          asaas_id: string
          company_id: string
          created_at?: string
          customer_id?: string | null
          effective_date?: string | null
          error_message?: string | null
          id?: string
          net_value?: number | null
          number?: string | null
          observations?: string | null
          payment_id?: string | null
          pdf_url?: string | null
          service_description?: string | null
          status: string
          taxes?: Json | null
          updated_at?: string
          value?: number | null
          xml_url?: string | null
        }
        Update: {
          asaas_id?: string
          company_id?: string
          created_at?: string
          customer_id?: string | null
          effective_date?: string | null
          error_message?: string | null
          id?: string
          net_value?: number | null
          number?: string | null
          observations?: string | null
          payment_id?: string | null
          pdf_url?: string | null
          service_description?: string | null
          status?: string
          taxes?: Json | null
          updated_at?: string
          value?: number | null
          xml_url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_invoices_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_payments: {
        Row: {
          asaas_id: string
          bank_slip_url: string | null
          billing_type: string | null
          chargeback: Json | null
          company_id: string
          confirmed_date: string | null
          created_at: string
          credit_card: Json | null
          credit_date: string | null
          customer_id: string | null
          description: string | null
          discount: Json | null
          due_date: string | null
          external_reference: string | null
          fine: Json | null
          id: string
          installment_id: string | null
          interest: Json | null
          invoice_url: string | null
          net_value: number | null
          payment_date: string | null
          payment_link: string | null
          pix_transaction: Json | null
          raw_payload: Json | null
          refunds: Json | null
          split: Json | null
          status: string
          subscription_id: string | null
          updated_at: string
          value: number | null
        }
        Insert: {
          asaas_id: string
          bank_slip_url?: string | null
          billing_type?: string | null
          chargeback?: Json | null
          company_id: string
          confirmed_date?: string | null
          created_at?: string
          credit_card?: Json | null
          credit_date?: string | null
          customer_id?: string | null
          description?: string | null
          discount?: Json | null
          due_date?: string | null
          external_reference?: string | null
          fine?: Json | null
          id?: string
          installment_id?: string | null
          interest?: Json | null
          invoice_url?: string | null
          net_value?: number | null
          payment_date?: string | null
          payment_link?: string | null
          pix_transaction?: Json | null
          raw_payload?: Json | null
          refunds?: Json | null
          split?: Json | null
          status: string
          subscription_id?: string | null
          updated_at?: string
          value?: number | null
        }
        Update: {
          asaas_id?: string
          bank_slip_url?: string | null
          billing_type?: string | null
          chargeback?: Json | null
          company_id?: string
          confirmed_date?: string | null
          created_at?: string
          credit_card?: Json | null
          credit_date?: string | null
          customer_id?: string | null
          description?: string | null
          discount?: Json | null
          due_date?: string | null
          external_reference?: string | null
          fine?: Json | null
          id?: string
          installment_id?: string | null
          interest?: Json | null
          invoice_url?: string | null
          net_value?: number | null
          payment_date?: string | null
          payment_link?: string | null
          pix_transaction?: Json | null
          raw_payload?: Json | null
          refunds?: Json | null
          split?: Json | null
          status?: string
          subscription_id?: string | null
          updated_at?: string
          value?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_payments_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_subscriptions: {
        Row: {
          asaas_id: string
          billing_type: string | null
          company_id: string
          created_at: string
          customer_id: string | null
          cycle: string | null
          description: string | null
          end_date: string | null
          external_reference: string | null
          id: string
          max_payments: number | null
          next_due_date: string | null
          payment_count: number | null
          raw_payload: Json | null
          status: string
          updated_at: string
          value: number | null
        }
        Insert: {
          asaas_id: string
          billing_type?: string | null
          company_id: string
          created_at?: string
          customer_id?: string | null
          cycle?: string | null
          description?: string | null
          end_date?: string | null
          external_reference?: string | null
          id?: string
          max_payments?: number | null
          next_due_date?: string | null
          payment_count?: number | null
          raw_payload?: Json | null
          status: string
          updated_at?: string
          value?: number | null
        }
        Update: {
          asaas_id?: string
          billing_type?: string | null
          company_id?: string
          created_at?: string
          customer_id?: string | null
          cycle?: string | null
          description?: string | null
          end_date?: string | null
          external_reference?: string | null
          id?: string
          max_payments?: number | null
          next_due_date?: string | null
          payment_count?: number | null
          raw_payload?: Json | null
          status?: string
          updated_at?: string
          value?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_subscriptions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_transfers: {
        Row: {
          asaas_id: string
          authorized: boolean | null
          bank_account: Json | null
          company_id: string
          created_at: string
          description: string | null
          external_reference: string | null
          fee: number | null
          id: string
          net_value: number | null
          operation_type: string | null
          raw_payload: Json | null
          scheduled_date: string | null
          status: string
          transaction_receipt_url: string | null
          transfer_fee: number | null
          type: string | null
          updated_at: string
          value: number | null
        }
        Insert: {
          asaas_id: string
          authorized?: boolean | null
          bank_account?: Json | null
          company_id: string
          created_at?: string
          description?: string | null
          external_reference?: string | null
          fee?: number | null
          id?: string
          net_value?: number | null
          operation_type?: string | null
          raw_payload?: Json | null
          scheduled_date?: string | null
          status: string
          transaction_receipt_url?: string | null
          transfer_fee?: number | null
          type?: string | null
          updated_at?: string
          value?: number | null
        }
        Update: {
          asaas_id?: string
          authorized?: boolean | null
          bank_account?: Json | null
          company_id?: string
          created_at?: string
          description?: string | null
          external_reference?: string | null
          fee?: number | null
          id?: string
          net_value?: number | null
          operation_type?: string | null
          raw_payload?: Json | null
          scheduled_date?: string | null
          status?: string
          transaction_receipt_url?: string | null
          transfer_fee?: number | null
          type?: string | null
          updated_at?: string
          value?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_transfers_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_asaas_webhook_events: {
        Row: {
          company_id: string
          created_at: string
          entity_id: string | null
          entity_type: string | null
          error_message: string | null
          event_category: string | null
          event_id: string
          event_type: string
          id: string
          payload: Json
          processed: boolean
          processed_at: string | null
        }
        Insert: {
          company_id: string
          created_at?: string
          entity_id?: string | null
          entity_type?: string | null
          error_message?: string | null
          event_category?: string | null
          event_id: string
          event_type: string
          id?: string
          payload?: Json
          processed?: boolean
          processed_at?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string
          entity_id?: string | null
          entity_type?: string | null
          error_message?: string | null
          event_category?: string | null
          event_id?: string
          event_type?: string
          id?: string
          payload?: Json
          processed?: boolean
          processed_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_asaas_webhook_events_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_invites: {
        Row: {
          company_id: string
          created_at: string
          criado_por: string
          expires_at: string
          id: string
          role: string
          token: string
          used_at: string | null
          used_by: string | null
        }
        Insert: {
          company_id: string
          created_at?: string
          criado_por: string
          expires_at?: string
          id?: string
          role?: string
          token?: string
          used_at?: string | null
          used_by?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string
          criado_por?: string
          expires_at?: string
          id?: string
          role?: string
          token?: string
          used_at?: string | null
          used_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_invites_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      company_journal_entries: {
        Row: {
          amount: number
          company_id: string
          created_at: string
          credit_account: string | null
          date: string
          debit_account: string | null
          description: string | null
          id: string
          transaction_id: string | null
        }
        Insert: {
          amount?: number
          company_id: string
          created_at?: string
          credit_account?: string | null
          date: string
          debit_account?: string | null
          description?: string | null
          id?: string
          transaction_id?: string | null
        }
        Update: {
          amount?: number
          company_id?: string
          created_at?: string
          credit_account?: string | null
          date?: string
          debit_account?: string | null
          description?: string | null
          id?: string
          transaction_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_journal_entries_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "company_journal_entries_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      company_members: {
        Row: {
          approval_limit: number | null
          company_id: string
          created_at: string
          id: string
          onboarding_completed: boolean
          role: string
          updated_at: string
          user_id: string
        }
        Insert: {
          approval_limit?: number | null
          company_id: string
          created_at?: string
          id?: string
          onboarding_completed?: boolean
          role?: string
          updated_at?: string
          user_id: string
        }
        Update: {
          approval_limit?: number | null
          company_id?: string
          created_at?: string
          id?: string
          onboarding_completed?: boolean
          role?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "company_members_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      contaazul_config: {
        Row: {
          ativo: boolean
          client_id_preview: string | null
          company_id: string
          created_at: string
          id: string
          last_import_at: string | null
          last_import_result: Json | null
          updated_at: string
        }
        Insert: {
          ativo?: boolean
          client_id_preview?: string | null
          company_id: string
          created_at?: string
          id?: string
          last_import_at?: string | null
          last_import_result?: Json | null
          updated_at?: string
        }
        Update: {
          ativo?: boolean
          client_id_preview?: string | null
          company_id?: string
          created_at?: string
          id?: string
          last_import_at?: string | null
          last_import_result?: Json | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "contaazul_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: true
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      contacts: {
        Row: {
          active: boolean
          city: string | null
          company_id: string
          complement: string | null
          created_at: string
          credit_limit: number | null
          default_payment_terms: number | null
          document: string | null
          email: string | null
          id: string
          name: string
          neighborhood: string | null
          notes: string | null
          number: string | null
          person_type: string | null
          phone: string | null
          state: string | null
          state_registration: string | null
          street: string | null
          trade_name: string | null
          type: string
          updated_at: string
          website: string | null
          whatsapp: string | null
          zip_code: string | null
        }
        Insert: {
          active?: boolean
          city?: string | null
          company_id: string
          complement?: string | null
          created_at?: string
          credit_limit?: number | null
          default_payment_terms?: number | null
          document?: string | null
          email?: string | null
          id?: string
          name: string
          neighborhood?: string | null
          notes?: string | null
          number?: string | null
          person_type?: string | null
          phone?: string | null
          state?: string | null
          state_registration?: string | null
          street?: string | null
          trade_name?: string | null
          type?: string
          updated_at?: string
          website?: string | null
          whatsapp?: string | null
          zip_code?: string | null
        }
        Update: {
          active?: boolean
          city?: string | null
          company_id?: string
          complement?: string | null
          created_at?: string
          credit_limit?: number | null
          default_payment_terms?: number | null
          document?: string | null
          email?: string | null
          id?: string
          name?: string
          neighborhood?: string | null
          notes?: string | null
          number?: string | null
          person_type?: string | null
          phone?: string | null
          state?: string | null
          state_registration?: string | null
          street?: string | null
          trade_name?: string | null
          type?: string
          updated_at?: string
          website?: string | null
          whatsapp?: string | null
          zip_code?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "contacts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      contracts: {
        Row: {
          account_id: string | null
          amount: number
          asaas_customer_id: string | null
          asaas_subscription_id: string | null
          billing_day: number
          company_id: string
          contact_id: string | null
          cost_center_id: string | null
          created_at: string
          cycle: string
          description: string
          end_date: string | null
          id: string
          next_due_date: string | null
          payment_method: string
          start_date: string
          status: string
          updated_at: string
        }
        Insert: {
          account_id?: string | null
          amount?: number
          asaas_customer_id?: string | null
          asaas_subscription_id?: string | null
          billing_day?: number
          company_id: string
          contact_id?: string | null
          cost_center_id?: string | null
          created_at?: string
          cycle?: string
          description: string
          end_date?: string | null
          id?: string
          next_due_date?: string | null
          payment_method?: string
          start_date?: string
          status?: string
          updated_at?: string
        }
        Update: {
          account_id?: string | null
          amount?: number
          asaas_customer_id?: string | null
          asaas_subscription_id?: string | null
          billing_day?: number
          company_id?: string
          contact_id?: string | null
          cost_center_id?: string | null
          created_at?: string
          cycle?: string
          description?: string
          end_date?: string | null
          id?: string
          next_due_date?: string | null
          payment_method?: string
          start_date?: string
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "contracts_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "contracts_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "contracts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "contracts_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "contracts_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "contracts_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "contracts_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "contracts_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
        ]
      }
      cost_centers: {
        Row: {
          active: boolean
          category: string | null
          company_id: string
          created_at: string
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          category?: string | null
          company_id: string
          created_at?: string
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          category?: string | null
          company_id?: string
          created_at?: string
          id?: string
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "cost_centers_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      fiscal_files: {
        Row: {
          company_id: string
          created_at: string
          file_size: string | null
          file_url: string | null
          id: string
          nome: string
          source: string
          tipo: string
          updated_at: string
        }
        Insert: {
          company_id: string
          created_at?: string
          file_size?: string | null
          file_url?: string | null
          id?: string
          nome: string
          source?: string
          tipo: string
          updated_at?: string
        }
        Update: {
          company_id?: string
          created_at?: string
          file_size?: string | null
          file_url?: string | null
          id?: string
          nome?: string
          source?: string
          tipo?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fiscal_files_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      focus_config: {
        Row: {
          active: boolean
          company_id: string
          created_at: string
          environment: string
          id: string
          last_emission_at: string | null
          last_test_at: string | null
          last_test_status: string | null
          token_homologacao: string | null
          token_homologacao_preview: string | null
          token_producao: string | null
          token_producao_preview: string | null
          updated_at: string
        }
        Insert: {
          active?: boolean
          company_id: string
          created_at?: string
          environment?: string
          id?: string
          last_emission_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          token_homologacao?: string | null
          token_homologacao_preview?: string | null
          token_producao?: string | null
          token_producao_preview?: string | null
          updated_at?: string
        }
        Update: {
          active?: boolean
          company_id?: string
          created_at?: string
          environment?: string
          id?: string
          last_emission_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          token_homologacao?: string | null
          token_homologacao_preview?: string | null
          token_producao?: string | null
          token_producao_preview?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "focus_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: true
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      inter_config: {
        Row: {
          account_number: string | null
          active: boolean
          bank_account_id: string | null
          cert_pem: string | null
          client_id: string | null
          client_secret: string | null
          company_id: string
          created_at: string
          environment: string
          id: string
          key_pem: string | null
          last_balance: number | null
          last_balance_at: string | null
          last_sync_at: string | null
          last_test_at: string | null
          last_test_status: string | null
          updated_at: string
        }
        Insert: {
          account_number?: string | null
          active?: boolean
          bank_account_id?: string | null
          cert_pem?: string | null
          client_id?: string | null
          client_secret?: string | null
          company_id: string
          created_at?: string
          environment?: string
          id?: string
          key_pem?: string | null
          last_balance?: number | null
          last_balance_at?: string | null
          last_sync_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          updated_at?: string
        }
        Update: {
          account_number?: string | null
          active?: boolean
          bank_account_id?: string | null
          cert_pem?: string | null
          client_id?: string | null
          client_secret?: string | null
          company_id?: string
          created_at?: string
          environment?: string
          id?: string
          key_pem?: string | null
          last_balance?: number | null
          last_balance_at?: string | null
          last_sync_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "inter_config_bank_account_id_fkey"
            columns: ["bank_account_id"]
            isOneToOne: false
            referencedRelation: "bank_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inter_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: true
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      invoices: {
        Row: {
          access_key: string | null
          cancelled_at: string | null
          cbs_valor: number | null
          cclasstrib: string | null
          company_id: string
          contact_id: string | null
          created_at: string
          ibs_valor: number | null
          id: string
          issue_date: string
          notes: string | null
          number: string | null
          pdf_url: string | null
          sales_order_id: string | null
          series: string | null
          status: string
          total: number
          type: string
          updated_at: string
          xml_content: string | null
        }
        Insert: {
          access_key?: string | null
          cancelled_at?: string | null
          cbs_valor?: number | null
          cclasstrib?: string | null
          company_id: string
          contact_id?: string | null
          created_at?: string
          ibs_valor?: number | null
          id?: string
          issue_date?: string
          notes?: string | null
          number?: string | null
          pdf_url?: string | null
          sales_order_id?: string | null
          series?: string | null
          status?: string
          total?: number
          type?: string
          updated_at?: string
          xml_content?: string | null
        }
        Update: {
          access_key?: string | null
          cancelled_at?: string | null
          cbs_valor?: number | null
          cclasstrib?: string | null
          company_id?: string
          contact_id?: string | null
          created_at?: string
          ibs_valor?: number | null
          id?: string
          issue_date?: string
          notes?: string | null
          number?: string | null
          pdf_url?: string | null
          sales_order_id?: string | null
          series?: string | null
          status?: string
          total?: number
          type?: string
          updated_at?: string
          xml_content?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "invoices_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "invoices_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "invoices_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "invoices_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "invoices_sales_order_id_fkey"
            columns: ["sales_order_id"]
            isOneToOne: false
            referencedRelation: "sales_orders"
            referencedColumns: ["id"]
          },
        ]
      }
      kpi_metas: {
        Row: {
          alvo: number
          company_id: string
          created_at: string
          direcao: string
          id: string
          metric_key: string
          updated_at: string
        }
        Insert: {
          alvo?: number
          company_id: string
          created_at?: string
          direcao?: string
          id?: string
          metric_key: string
          updated_at?: string
        }
        Update: {
          alvo?: number
          company_id?: string
          created_at?: string
          direcao?: string
          id?: string
          metric_key?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "kpi_metas_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      monthly_close: {
        Row: {
          closed_at: string | null
          closed_by: string | null
          company_id: string
          created_at: string
          id: string
          month: string
          reopen_reason: string | null
          reopened_at: string | null
          reopened_by: string | null
          snapshot: Json | null
          status: string
          updated_at: string
        }
        Insert: {
          closed_at?: string | null
          closed_by?: string | null
          company_id: string
          created_at?: string
          id?: string
          month: string
          reopen_reason?: string | null
          reopened_at?: string | null
          reopened_by?: string | null
          snapshot?: Json | null
          status?: string
          updated_at?: string
        }
        Update: {
          closed_at?: string | null
          closed_by?: string | null
          company_id?: string
          created_at?: string
          id?: string
          month?: string
          reopen_reason?: string | null
          reopened_at?: string | null
          reopened_by?: string | null
          snapshot?: Json | null
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "monthly_close_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      municipalities: {
        Row: {
          code_ibge: string
          created_at: string
          name: string
          region: string | null
          uf: string | null
          updated_at: string
        }
        Insert: {
          code_ibge: string
          created_at?: string
          name: string
          region?: string | null
          uf?: string | null
          updated_at?: string
        }
        Update: {
          code_ibge?: string
          created_at?: string
          name?: string
          region?: string | null
          uf?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      nfse_config: {
        Row: {
          active: boolean
          ambiente: string
          cert_password: string | null
          cert_pfx_base64: string | null
          cert_set: boolean | null
          codigo_municipio: string | null
          company_id: string
          created_at: string
          id: string
          inscricao_municipal: string | null
          last_emission_at: string | null
          last_test_at: string | null
          last_test_status: string | null
          proximo_numero_dps: number
          serie_dps: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          ambiente?: string
          cert_password?: string | null
          cert_pfx_base64?: string | null
          cert_set?: boolean | null
          codigo_municipio?: string | null
          company_id: string
          created_at?: string
          id?: string
          inscricao_municipal?: string | null
          last_emission_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          proximo_numero_dps?: number
          serie_dps?: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          ambiente?: string
          cert_password?: string | null
          cert_pfx_base64?: string | null
          cert_set?: boolean | null
          codigo_municipio?: string | null
          company_id?: string
          created_at?: string
          id?: string
          inscricao_municipal?: string | null
          last_emission_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          proximo_numero_dps?: number
          serie_dps?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "nfse_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: true
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          agent_instance_id: string | null
          categoria: string
          company_id: string
          corpo: string | null
          created_at: string
          dedupe_key: string | null
          id: string
          lida: boolean
          link: string | null
          titulo: string
        }
        Insert: {
          agent_instance_id?: string | null
          categoria?: string
          company_id: string
          corpo?: string | null
          created_at?: string
          dedupe_key?: string | null
          id?: string
          lida?: boolean
          link?: string | null
          titulo: string
        }
        Update: {
          agent_instance_id?: string | null
          categoria?: string
          company_id?: string
          corpo?: string | null
          created_at?: string
          dedupe_key?: string | null
          id?: string
          lida?: boolean
          link?: string | null
          titulo?: string
        }
        Relationships: [
          {
            foreignKeyName: "notifications_agent_instance_id_fkey"
            columns: ["agent_instance_id"]
            isOneToOne: false
            referencedRelation: "agent_instances"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "notifications_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      openfinance_config: {
        Row: {
          active: boolean
          client_id_preview: string | null
          company_id: string
          created_at: string
          id: string
          last_sync_at: string | null
          last_test_at: string | null
          last_test_status: string | null
          provider: string
          sandbox: boolean
          updated_at: string
        }
        Insert: {
          active?: boolean
          client_id_preview?: string | null
          company_id: string
          created_at?: string
          id?: string
          last_sync_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          provider?: string
          sandbox?: boolean
          updated_at?: string
        }
        Update: {
          active?: boolean
          client_id_preview?: string | null
          company_id?: string
          created_at?: string
          id?: string
          last_sync_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          provider?: string
          sandbox?: boolean
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "openfinance_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      owner_transactions: {
        Row: {
          amount: number
          company_id: string
          created_at: string
          date: string
          description: string | null
          id: string
          pj_bank_account_id: string | null
          pj_transaction_id: string | null
          status: string
          transaction_type: string
          updated_at: string
          user_id: string
        }
        Insert: {
          amount?: number
          company_id: string
          created_at?: string
          date?: string
          description?: string | null
          id?: string
          pj_bank_account_id?: string | null
          pj_transaction_id?: string | null
          status?: string
          transaction_type: string
          updated_at?: string
          user_id?: string
        }
        Update: {
          amount?: number
          company_id?: string
          created_at?: string
          date?: string
          description?: string | null
          id?: string
          pj_bank_account_id?: string | null
          pj_transaction_id?: string | null
          status?: string
          transaction_type?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "owner_transactions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "owner_transactions_pj_bank_account_id_fkey"
            columns: ["pj_bank_account_id"]
            isOneToOne: false
            referencedRelation: "bank_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "owner_transactions_pj_transaction_id_fkey"
            columns: ["pj_transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      platform_settings: {
        Row: {
          cadastro_aberto: boolean
          created_at: string
          functions_url: string | null
          id: boolean
          owner_user_id: string | null
          plataforma_bloqueada: boolean
          updated_at: string
        }
        Insert: {
          cadastro_aberto?: boolean
          created_at?: string
          functions_url?: string | null
          id?: boolean
          owner_user_id?: string | null
          plataforma_bloqueada?: boolean
          updated_at?: string
        }
        Update: {
          cadastro_aberto?: boolean
          created_at?: string
          functions_url?: string | null
          id?: boolean
          owner_user_id?: string | null
          plataforma_bloqueada?: boolean
          updated_at?: string
        }
        Relationships: []
      }
      plugnotas_config: {
        Row: {
          active: boolean
          api_key: string | null
          api_key_set: boolean | null
          company_id: string
          created_at: string
          enabled_cte: boolean
          enabled_mdfe: boolean
          enabled_nfce: boolean
          enabled_nfe: boolean
          enabled_nfse: boolean
          environment: string
          id: string
          last_emission_at: string | null
          last_test_at: string | null
          last_test_status: string | null
          plugnotas_empresa_cnpj: string | null
          plugnotas_empresa_id: string | null
          serie_padrao: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          api_key?: string | null
          api_key_set?: boolean | null
          company_id: string
          created_at?: string
          enabled_cte?: boolean
          enabled_mdfe?: boolean
          enabled_nfce?: boolean
          enabled_nfe?: boolean
          enabled_nfse?: boolean
          environment?: string
          id?: string
          last_emission_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          plugnotas_empresa_cnpj?: string | null
          plugnotas_empresa_id?: string | null
          serie_padrao?: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          api_key?: string | null
          api_key_set?: boolean | null
          company_id?: string
          created_at?: string
          enabled_cte?: boolean
          enabled_mdfe?: boolean
          enabled_nfce?: boolean
          enabled_nfe?: boolean
          enabled_nfse?: boolean
          environment?: string
          id?: string
          last_emission_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          plugnotas_empresa_cnpj?: string | null
          plugnotas_empresa_id?: string | null
          serie_padrao?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "plugnotas_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: true
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      plugnotas_documents: {
        Row: {
          cancelled_at: string | null
          cbs_aliquota: number | null
          cbs_valor: number | null
          cclasstrib: string | null
          chave_acesso: string | null
          company_id: string
          created_at: string
          doc_type: string
          emitted_at: string | null
          ibs_aliquota: number | null
          ibs_valor: number | null
          id: string
          invoice_id: string | null
          numero: string | null
          payload_request: Json | null
          payload_response: Json | null
          plugnotas_id: string | null
          serie: string | null
          status: string
          status_message: string | null
          updated_at: string
        }
        Insert: {
          cancelled_at?: string | null
          cbs_aliquota?: number | null
          cbs_valor?: number | null
          cclasstrib?: string | null
          chave_acesso?: string | null
          company_id: string
          created_at?: string
          doc_type: string
          emitted_at?: string | null
          ibs_aliquota?: number | null
          ibs_valor?: number | null
          id?: string
          invoice_id?: string | null
          numero?: string | null
          payload_request?: Json | null
          payload_response?: Json | null
          plugnotas_id?: string | null
          serie?: string | null
          status: string
          status_message?: string | null
          updated_at?: string
        }
        Update: {
          cancelled_at?: string | null
          cbs_aliquota?: number | null
          cbs_valor?: number | null
          cclasstrib?: string | null
          chave_acesso?: string | null
          company_id?: string
          created_at?: string
          doc_type?: string
          emitted_at?: string | null
          ibs_aliquota?: number | null
          ibs_valor?: number | null
          id?: string
          invoice_id?: string | null
          numero?: string | null
          payload_request?: Json | null
          payload_response?: Json | null
          plugnotas_id?: string | null
          serie?: string | null
          status?: string
          status_message?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "plugnotas_documents_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "plugnotas_documents_invoice_id_fkey"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["id"]
          },
        ]
      }
      products: {
        Row: {
          account_id: string | null
          active: boolean
          barcode: string | null
          category: string | null
          cclasstrib: string | null
          cfop: string | null
          company_id: string
          cost_price: number | null
          created_at: string
          current_stock: number | null
          description: string | null
          id: string
          min_stock: number | null
          name: string
          ncm: string | null
          sell_price: number
          sku: string | null
          tax_origin: string | null
          track_stock: boolean
          type: string
          unit: string
          updated_at: string
        }
        Insert: {
          account_id?: string | null
          active?: boolean
          barcode?: string | null
          category?: string | null
          cclasstrib?: string | null
          cfop?: string | null
          company_id: string
          cost_price?: number | null
          created_at?: string
          current_stock?: number | null
          description?: string | null
          id?: string
          min_stock?: number | null
          name: string
          ncm?: string | null
          sell_price?: number
          sku?: string | null
          tax_origin?: string | null
          track_stock?: boolean
          type?: string
          unit?: string
          updated_at?: string
        }
        Update: {
          account_id?: string | null
          active?: boolean
          barcode?: string | null
          category?: string | null
          cclasstrib?: string | null
          cfop?: string | null
          company_id?: string
          cost_price?: number | null
          created_at?: string
          current_stock?: number | null
          description?: string | null
          id?: string
          min_stock?: number | null
          name?: string
          ncm?: string | null
          sell_price?: number
          sku?: string | null
          tax_origin?: string | null
          track_stock?: boolean
          type?: string
          unit?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "products_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "products_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      purchase_order_items: {
        Row: {
          created_at: string
          description: string
          id: string
          order_id: string
          product_id: string | null
          quantity: number
          sort_order: number
          total: number
          unit_price: number
        }
        Insert: {
          created_at?: string
          description?: string
          id?: string
          order_id: string
          product_id?: string | null
          quantity?: number
          sort_order?: number
          total?: number
          unit_price?: number
        }
        Update: {
          created_at?: string
          description?: string
          id?: string
          order_id?: string
          product_id?: string | null
          quantity?: number
          sort_order?: number
          total?: number
          unit_price?: number
        }
        Relationships: [
          {
            foreignKeyName: "purchase_order_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "purchase_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      purchase_orders: {
        Row: {
          company_id: string
          contact_id: string | null
          created_at: string
          discount_value: number
          expected_date: string | null
          id: string
          issue_date: string
          notes: string | null
          order_number: number | null
          payment_terms: string | null
          shipping: number
          status: string
          subtotal: number
          total: number
          updated_at: string
          user_id: string | null
        }
        Insert: {
          company_id: string
          contact_id?: string | null
          created_at?: string
          discount_value?: number
          expected_date?: string | null
          id?: string
          issue_date?: string
          notes?: string | null
          order_number?: number | null
          payment_terms?: string | null
          shipping?: number
          status?: string
          subtotal?: number
          total?: number
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          company_id?: string
          contact_id?: string | null
          created_at?: string
          discount_value?: number
          expected_date?: string | null
          id?: string
          issue_date?: string
          notes?: string | null
          order_number?: number | null
          payment_terms?: string | null
          shipping?: number
          status?: string
          subtotal?: number
          total?: number
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "purchase_orders_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_orders_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchase_orders_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "purchase_orders_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
        ]
      }
      receivables: {
        Row: {
          account_id: string | null
          amount: number
          asaas_payment_id: string | null
          boleto_url: string | null
          company_id: string
          contact_id: string | null
          contract_id: string | null
          cost_center_id: string | null
          created_at: string
          description: string
          due_date: string
          id: string
          payment_date: string | null
          pix_url: string | null
          source: string
          status: string
          stripe_checkout_url: string | null
          stripe_payment_intent_id: string | null
          transaction_id: string | null
          updated_at: string
        }
        Insert: {
          account_id?: string | null
          amount: number
          asaas_payment_id?: string | null
          boleto_url?: string | null
          company_id: string
          contact_id?: string | null
          contract_id?: string | null
          cost_center_id?: string | null
          created_at?: string
          description: string
          due_date: string
          id?: string
          payment_date?: string | null
          pix_url?: string | null
          source?: string
          status?: string
          stripe_checkout_url?: string | null
          stripe_payment_intent_id?: string | null
          transaction_id?: string | null
          updated_at?: string
        }
        Update: {
          account_id?: string | null
          amount?: number
          asaas_payment_id?: string | null
          boleto_url?: string | null
          company_id?: string
          contact_id?: string | null
          contract_id?: string | null
          cost_center_id?: string | null
          created_at?: string
          description?: string
          due_date?: string
          id?: string
          payment_date?: string | null
          pix_url?: string | null
          source?: string
          status?: string
          stripe_checkout_url?: string | null
          stripe_payment_intent_id?: string | null
          transaction_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "receivables_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receivables_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "receivables_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receivables_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receivables_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "receivables_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "receivables_contract_id_fkey"
            columns: ["contract_id"]
            isOneToOne: false
            referencedRelation: "contracts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receivables_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receivables_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
          {
            foreignKeyName: "receivables_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      reconciliation_log: {
        Row: {
          company_id: string
          created_at: string
          decision: string
          id: string
          kept_transaction_id: string | null
          removed_snapshot: Json | null
          removed_transaction_id: string | null
          resolved_by: string | null
        }
        Insert: {
          company_id: string
          created_at?: string
          decision?: string
          id?: string
          kept_transaction_id?: string | null
          removed_snapshot?: Json | null
          removed_transaction_id?: string | null
          resolved_by?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string
          decision?: string
          id?: string
          kept_transaction_id?: string | null
          removed_snapshot?: Json | null
          removed_transaction_id?: string | null
          resolved_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "reconciliation_log_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      sales_order_items: {
        Row: {
          created_at: string
          description: string
          discount_percent: number
          id: string
          order_id: string
          product_id: string | null
          quantity: number
          sort_order: number
          total: number
          unit_price: number
        }
        Insert: {
          created_at?: string
          description?: string
          discount_percent?: number
          id?: string
          order_id: string
          product_id?: string | null
          quantity?: number
          sort_order?: number
          total?: number
          unit_price?: number
        }
        Update: {
          created_at?: string
          description?: string
          discount_percent?: number
          id?: string
          order_id?: string
          product_id?: string | null
          quantity?: number
          sort_order?: number
          total?: number
          unit_price?: number
        }
        Relationships: [
          {
            foreignKeyName: "sales_order_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "sales_orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sales_order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      sales_orders: {
        Row: {
          company_id: string
          contact_id: string | null
          created_at: string
          discount_value: number
          due_date: string | null
          id: string
          issue_date: string
          notes: string | null
          order_number: number | null
          salesperson: string | null
          salesperson_id: string | null
          shipping: number
          status: string
          subtotal: number
          total: number
          updated_at: string
          user_id: string | null
        }
        Insert: {
          company_id: string
          contact_id?: string | null
          created_at?: string
          discount_value?: number
          due_date?: string | null
          id?: string
          issue_date?: string
          notes?: string | null
          order_number?: number | null
          salesperson?: string | null
          salesperson_id?: string | null
          shipping?: number
          status?: string
          subtotal?: number
          total?: number
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          company_id?: string
          contact_id?: string | null
          created_at?: string
          discount_value?: number
          due_date?: string | null
          id?: string
          issue_date?: string
          notes?: string | null
          order_number?: number | null
          salesperson?: string | null
          salesperson_id?: string | null
          shipping?: number
          status?: string
          subtotal?: number
          total?: number
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sales_orders_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sales_orders_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sales_orders_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "sales_orders_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
        ]
      }
      stock_movements: {
        Row: {
          company_id: string
          created_at: string
          id: string
          notes: string | null
          product_id: string
          quantity: number
          reference_id: string | null
          reference_type: string | null
          type: string
          unit_cost: number | null
          user_id: string | null
          warehouse_id: string | null
        }
        Insert: {
          company_id: string
          created_at?: string
          id?: string
          notes?: string | null
          product_id: string
          quantity: number
          reference_id?: string | null
          reference_type?: string | null
          type: string
          unit_cost?: number | null
          user_id?: string | null
          warehouse_id?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string
          id?: string
          notes?: string | null
          product_id?: string
          quantity?: number
          reference_id?: string | null
          reference_type?: string | null
          type?: string
          unit_cost?: number | null
          user_id?: string | null
          warehouse_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "stock_movements_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stock_movements_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stock_movements_warehouse_id_fkey"
            columns: ["warehouse_id"]
            isOneToOne: false
            referencedRelation: "warehouses"
            referencedColumns: ["id"]
          },
        ]
      }
      stripe_charges: {
        Row: {
          amount_bruto: number
          amount_liquido: number
          amount_taxa: number
          balance_transaction_id: string | null
          company_id: string
          config_id: string
          created_at: string
          currency: string
          customer_email: string | null
          description: string | null
          id: string
          paid_at: string | null
          payout_id: string | null
          raw: Json | null
          receivable_id: string | null
          status: string | null
          stripe_id: string
          transaction_id: string | null
          updated_at: string
        }
        Insert: {
          amount_bruto?: number
          amount_liquido?: number
          amount_taxa?: number
          balance_transaction_id?: string | null
          company_id: string
          config_id: string
          created_at?: string
          currency?: string
          customer_email?: string | null
          description?: string | null
          id?: string
          paid_at?: string | null
          payout_id?: string | null
          raw?: Json | null
          receivable_id?: string | null
          status?: string | null
          stripe_id: string
          transaction_id?: string | null
          updated_at?: string
        }
        Update: {
          amount_bruto?: number
          amount_liquido?: number
          amount_taxa?: number
          balance_transaction_id?: string | null
          company_id?: string
          config_id?: string
          created_at?: string
          currency?: string
          customer_email?: string | null
          description?: string | null
          id?: string
          paid_at?: string | null
          payout_id?: string | null
          raw?: Json | null
          receivable_id?: string | null
          status?: string | null
          stripe_id?: string
          transaction_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "stripe_charges_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_charges_config_id_fkey"
            columns: ["config_id"]
            isOneToOne: false
            referencedRelation: "stripe_config"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_charges_receivable_id_fkey"
            columns: ["receivable_id"]
            isOneToOne: false
            referencedRelation: "receivables"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_charges_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      stripe_config: {
        Row: {
          active: boolean
          apelido: string
          centro_custo_taxa_id: string | null
          company_id: string
          conta_taxa_id: string | null
          created_at: string
          id: string
          last_sync_at: string | null
          last_test_at: string | null
          last_test_status: string | null
          mode: string
          publishable_key: string | null
          secret_key_preview: string | null
          updated_at: string
          webhook_secret_preview: string | null
        }
        Insert: {
          active?: boolean
          apelido?: string
          centro_custo_taxa_id?: string | null
          company_id: string
          conta_taxa_id?: string | null
          created_at?: string
          id?: string
          last_sync_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          mode?: string
          publishable_key?: string | null
          secret_key_preview?: string | null
          updated_at?: string
          webhook_secret_preview?: string | null
        }
        Update: {
          active?: boolean
          apelido?: string
          centro_custo_taxa_id?: string | null
          company_id?: string
          conta_taxa_id?: string | null
          created_at?: string
          id?: string
          last_sync_at?: string | null
          last_test_at?: string | null
          last_test_status?: string | null
          mode?: string
          publishable_key?: string | null
          secret_key_preview?: string | null
          updated_at?: string
          webhook_secret_preview?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "stripe_config_centro_custo_taxa_id_fkey"
            columns: ["centro_custo_taxa_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_config_centro_custo_taxa_id_fkey"
            columns: ["centro_custo_taxa_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
          {
            foreignKeyName: "stripe_config_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_config_conta_taxa_id_fkey"
            columns: ["conta_taxa_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_config_conta_taxa_id_fkey"
            columns: ["conta_taxa_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
        ]
      }
      stripe_events: {
        Row: {
          company_id: string
          created_at: string
          id: string
          raw: Json | null
          stripe_event_id: string
          type: string | null
        }
        Insert: {
          company_id: string
          created_at?: string
          id?: string
          raw?: Json | null
          stripe_event_id: string
          type?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string
          id?: string
          raw?: Json | null
          stripe_event_id?: string
          type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "stripe_events_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      stripe_payouts: {
        Row: {
          amount_bruto: number
          amount_liquido: number
          amount_taxa: number
          arrival_date: string | null
          company_id: string
          composicao_fecha: boolean | null
          conciliado_at: string | null
          config_id: string
          created_at: string
          currency: string
          diferenca: number | null
          id: string
          itens: number
          raw: Json | null
          status: string | null
          stripe_id: string
          transaction_id: string | null
          updated_at: string
        }
        Insert: {
          amount_bruto?: number
          amount_liquido?: number
          amount_taxa?: number
          arrival_date?: string | null
          company_id: string
          composicao_fecha?: boolean | null
          conciliado_at?: string | null
          config_id: string
          created_at?: string
          currency?: string
          diferenca?: number | null
          id?: string
          itens?: number
          raw?: Json | null
          status?: string | null
          stripe_id: string
          transaction_id?: string | null
          updated_at?: string
        }
        Update: {
          amount_bruto?: number
          amount_liquido?: number
          amount_taxa?: number
          arrival_date?: string | null
          company_id?: string
          composicao_fecha?: boolean | null
          conciliado_at?: string | null
          config_id?: string
          created_at?: string
          currency?: string
          diferenca?: number | null
          id?: string
          itens?: number
          raw?: Json | null
          status?: string | null
          stripe_id?: string
          transaction_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "stripe_payouts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_payouts_config_id_fkey"
            columns: ["config_id"]
            isOneToOne: false
            referencedRelation: "stripe_config"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_payouts_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      tax_guides: {
        Row: {
          company_id: string
          competencia: string
          created_at: string
          id: string
          invoice_id: string | null
          source: string
          status: string
          tipo: string
          updated_at: string
          valor: number
          vencimento: string
        }
        Insert: {
          company_id: string
          competencia: string
          created_at?: string
          id?: string
          invoice_id?: string | null
          source?: string
          status?: string
          tipo: string
          updated_at?: string
          valor?: number
          vencimento: string
        }
        Update: {
          company_id?: string
          competencia?: string
          created_at?: string
          id?: string
          invoice_id?: string | null
          source?: string
          status?: string
          tipo?: string
          updated_at?: string
          valor?: number
          vencimento?: string
        }
        Relationships: [
          {
            foreignKeyName: "tax_guides_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tax_guides_invoice_id_fkey"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["id"]
          },
        ]
      }
      tax_rates: {
        Row: {
          confidence: string | null
          created_at: string
          ente_code: string
          id: string
          item_code: string | null
          notes: string | null
          rate: number
          source: string | null
          tax: string
          updated_at: string
          version: string | null
          vigencia_fim: string | null
          vigencia_inicio: string | null
        }
        Insert: {
          confidence?: string | null
          created_at?: string
          ente_code: string
          id?: string
          item_code?: string | null
          notes?: string | null
          rate: number
          source?: string | null
          tax: string
          updated_at?: string
          version?: string | null
          vigencia_fim?: string | null
          vigencia_inicio?: string | null
        }
        Update: {
          confidence?: string | null
          created_at?: string
          ente_code?: string
          id?: string
          item_code?: string | null
          notes?: string | null
          rate?: number
          source?: string | null
          tax?: string
          updated_at?: string
          version?: string | null
          vigencia_fim?: string | null
          vigencia_inicio?: string | null
        }
        Relationships: []
      }
      transaction_allocations: {
        Row: {
          cost_center_id: string
          created_at: string
          id: string
          percentual: number
          transaction_id: string
        }
        Insert: {
          cost_center_id: string
          created_at?: string
          id?: string
          percentual: number
          transaction_id: string
        }
        Update: {
          cost_center_id?: string
          created_at?: string
          id?: string
          percentual?: number
          transaction_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "transaction_allocations_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transaction_allocations_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
          {
            foreignKeyName: "transaction_allocations_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
      transactions: {
        Row: {
          account_id: string | null
          amount: number
          attachment_url: string | null
          bank_account_id: string | null
          company_id: string
          competencia_date: string | null
          confianca: number | null
          contact_id: string | null
          cost_center_id: string | null
          created_at: string
          date: string
          description: string
          external_id: string | null
          id: string
          payment_method: string | null
          project: string | null
          reconciled_at: string | null
          source: string
          status: string
          type: string
          updated_at: string
          user_id: string | null
        }
        Insert: {
          account_id?: string | null
          amount: number
          attachment_url?: string | null
          bank_account_id?: string | null
          company_id: string
          competencia_date?: string | null
          confianca?: number | null
          contact_id?: string | null
          cost_center_id?: string | null
          created_at?: string
          date?: string
          description: string
          external_id?: string | null
          id?: string
          payment_method?: string | null
          project?: string | null
          reconciled_at?: string | null
          source?: string
          status?: string
          type: string
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          account_id?: string | null
          amount?: number
          attachment_url?: string | null
          bank_account_id?: string | null
          company_id?: string
          competencia_date?: string | null
          confianca?: number | null
          contact_id?: string | null
          cost_center_id?: string | null
          created_at?: string
          date?: string
          description?: string
          external_id?: string | null
          id?: string
          payment_method?: string | null
          project?: string | null
          reconciled_at?: string | null
          source?: string
          status?: string
          type?: string
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transactions_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "transactions_bank_account_id_fkey"
            columns: ["bank_account_id"]
            isOneToOne: false
            referencedRelation: "bank_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "contacts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_cliente_360"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "transactions_contact_id_fkey"
            columns: ["contact_id"]
            isOneToOne: false
            referencedRelation: "v_recompra_clientes"
            referencedColumns: ["contact_id"]
          },
          {
            foreignKeyName: "transactions_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_cost_center_id_fkey"
            columns: ["cost_center_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
        ]
      }
      warehouses: {
        Row: {
          active: boolean
          address: string | null
          company_id: string
          created_at: string
          id: string
          is_default: boolean
          name: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          address?: string | null
          company_id: string
          created_at?: string
          id?: string
          is_default?: boolean
          name: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          address?: string | null
          company_id?: string
          created_at?: string
          id?: string
          is_default?: boolean
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "warehouses_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      webhook_logs: {
        Row: {
          company_id: string
          created_at: string
          direction: string
          error_message: string | null
          event: string | null
          id: string
          request_payload: Json | null
          response_body: string | null
          status_code: number | null
          success: boolean
          webhook_id: string
        }
        Insert: {
          company_id: string
          created_at?: string
          direction?: string
          error_message?: string | null
          event?: string | null
          id?: string
          request_payload?: Json | null
          response_body?: string | null
          status_code?: number | null
          success?: boolean
          webhook_id: string
        }
        Update: {
          company_id?: string
          created_at?: string
          direction?: string
          error_message?: string | null
          event?: string | null
          id?: string
          request_payload?: Json | null
          response_body?: string | null
          status_code?: number | null
          success?: boolean
          webhook_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "webhook_logs_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "webhook_logs_webhook_id_fkey"
            columns: ["webhook_id"]
            isOneToOne: false
            referencedRelation: "webhooks"
            referencedColumns: ["id"]
          },
        ]
      }
      webhooks: {
        Row: {
          active: boolean
          auto_create_transaction: boolean
          company_id: string
          created_at: string
          default_account_id: string | null
          default_cost_center_id: string | null
          default_type: string | null
          direction: string
          events: string[]
          id: string
          last_called_at: string | null
          name: string
          secret: string
          updated_at: string
          url: string | null
        }
        Insert: {
          active?: boolean
          auto_create_transaction?: boolean
          company_id: string
          created_at?: string
          default_account_id?: string | null
          default_cost_center_id?: string | null
          default_type?: string | null
          direction?: string
          events?: string[]
          id?: string
          last_called_at?: string | null
          name: string
          secret?: string
          updated_at?: string
          url?: string | null
        }
        Update: {
          active?: boolean
          auto_create_transaction?: boolean
          company_id?: string
          created_at?: string
          default_account_id?: string | null
          default_cost_center_id?: string | null
          default_type?: string | null
          direction?: string
          events?: string[]
          id?: string
          last_called_at?: string | null
          name?: string
          secret?: string
          updated_at?: string
          url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "webhooks_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "webhooks_default_account_id_fkey"
            columns: ["default_account_id"]
            isOneToOne: false
            referencedRelation: "chart_of_accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "webhooks_default_account_id_fkey"
            columns: ["default_account_id"]
            isOneToOne: false
            referencedRelation: "v_dre_linhas"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "webhooks_default_cost_center_id_fkey"
            columns: ["default_cost_center_id"]
            isOneToOne: false
            referencedRelation: "cost_centers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "webhooks_default_cost_center_id_fkey"
            columns: ["default_cost_center_id"]
            isOneToOne: false
            referencedRelation: "v_centro_custo_mes"
            referencedColumns: ["centro_id"]
          },
        ]
      }
      whatsapp_configs: {
        Row: {
          active: boolean
          company_id: string
          created_at: string
          evolution_api_key: string | null
          evolution_api_url: string | null
          group_jid: string | null
          group_name: string | null
          id: string
          instance_name: string
          notify_number: string | null
          phone_number: string | null
          updated_at: string
          webhook_secret: string | null
        }
        Insert: {
          active?: boolean
          company_id: string
          created_at?: string
          evolution_api_key?: string | null
          evolution_api_url?: string | null
          group_jid?: string | null
          group_name?: string | null
          id?: string
          instance_name: string
          notify_number?: string | null
          phone_number?: string | null
          updated_at?: string
          webhook_secret?: string | null
        }
        Update: {
          active?: boolean
          company_id?: string
          created_at?: string
          evolution_api_key?: string | null
          evolution_api_url?: string | null
          group_jid?: string | null
          group_name?: string | null
          id?: string
          instance_name?: string
          notify_number?: string | null
          phone_number?: string | null
          updated_at?: string
          webhook_secret?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "whatsapp_configs_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      whatsapp_messages: {
        Row: {
          classification: Json | null
          company_id: string
          config_id: string | null
          created_at: string
          direction: string
          error_message: string | null
          id: string
          media_url: string | null
          message_id: string | null
          message_text: string | null
          message_type: string
          phone_number: string | null
          processed: boolean
          transaction_id: string | null
        }
        Insert: {
          classification?: Json | null
          company_id: string
          config_id?: string | null
          created_at?: string
          direction?: string
          error_message?: string | null
          id?: string
          media_url?: string | null
          message_id?: string | null
          message_text?: string | null
          message_type?: string
          phone_number?: string | null
          processed?: boolean
          transaction_id?: string | null
        }
        Update: {
          classification?: Json | null
          company_id?: string
          config_id?: string | null
          created_at?: string
          direction?: string
          error_message?: string | null
          id?: string
          media_url?: string | null
          message_id?: string | null
          message_text?: string | null
          message_type?: string
          phone_number?: string | null
          processed?: boolean
          transaction_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "whatsapp_messages_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "whatsapp_messages_config_id_fkey"
            columns: ["config_id"]
            isOneToOne: false
            referencedRelation: "whatsapp_configs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "whatsapp_messages_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      v_centro_custo_mes: {
        Row: {
          centro_id: string | null
          centro_nome: string | null
          company_id: string | null
          mes: string | null
          total: number | null
          type: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transactions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_cliente_360: {
        Row: {
          company_id: string | null
          contact_id: string | null
          em_aberto: number | null
          faturado: number | null
          name: string | null
          ultima_cobranca: string | null
          whatsapp: string | null
        }
        Relationships: [
          {
            foreignKeyName: "contacts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_company_margin: {
        Row: {
          company_id: string | null
          custos: number | null
          despesas: number | null
          month: string | null
          receita: number | null
        }
        Relationships: [
          {
            foreignKeyName: "transactions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_dre_linhas: {
        Row: {
          account_code: string | null
          account_id: string | null
          account_name: string | null
          company_id: string | null
          grupo: string | null
          mes: string | null
          mes_competencia: string | null
          total: number | null
          type: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transactions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_group_account_totals: {
        Row: {
          company_id: string | null
          group_code: string | null
          group_name: string | null
          month: string | null
          total: number | null
          type: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transactions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_mrr_movimentos: {
        Row: {
          company_id: string | null
          contratos_novos: number | null
          contratos_perdidos: number | null
          mes: string | null
          mrr_ativo: number | null
          mrr_novo: number | null
          mrr_perdido: number | null
        }
        Relationships: [
          {
            foreignKeyName: "contracts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_recompra_clientes: {
        Row: {
          company_id: string | null
          contact_id: string | null
          dias_desde_ultima: number | null
          intervalo_medio_dias: number | null
          n_compras: number | null
          name: string | null
          primeira_compra: string | null
          proxima_esperada: string | null
          tem_contrato: boolean | null
          ticket_medio: number | null
          total_gasto: number | null
          ultima_compra: string | null
          whatsapp: string | null
        }
        Relationships: [
          {
            foreignKeyName: "contacts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      v_stripe_repasses: {
        Row: {
          amount_bruto: number | null
          amount_liquido: number | null
          amount_taxa: number | null
          arrival_date: string | null
          canal_nome: string | null
          company_id: string | null
          composicao_fecha: boolean | null
          conciliado_em: string | null
          config_id: string | null
          created_at: string | null
          currency: string | null
          diferenca: number | null
          itens: number | null
          status: string | null
          stripe_id: string | null
          transaction_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "stripe_payouts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_payouts_config_id_fkey"
            columns: ["config_id"]
            isOneToOne: false
            referencedRelation: "stripe_config"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "stripe_payouts_transaction_id_fkey"
            columns: ["transaction_id"]
            isOneToOne: false
            referencedRelation: "transactions"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      cadastro_esta_aberto: { Args: never; Returns: boolean }
      can_write_company: { Args: { _company_id: string }; Returns: boolean }
      consagrar_dono_se_primeiro: { Args: never; Returns: boolean }
      create_company_for_user: {
        Args: { company_cnpj?: string; company_name: string }
        Returns: string
      }
      demonstracao_disponivel: { Args: never; Returns: boolean }
      fechar_mes: {
        Args: { p_company_id: string; p_mes: string }
        Returns: Json
      }
      get_contaazul_credentials: {
        Args: { p_company_id: string }
        Returns: Json
      }
      get_pluggy_credentials: { Args: { p_company_id: string }; Returns: Json }
      get_stripe_credentials: { Args: { p_config_id: string }; Returns: Json }
      is_company_admin: { Args: { _company_id: string }; Returns: boolean }
      is_company_member: { Args: { _company_id: string }; Returns: boolean }
      limpar_demonstracao_se_remixado: { Args: never; Returns: undefined }
      plano_da_empresa: { Args: { p_company_id: string }; Returns: Json }
      plataforma_bloqueada: { Args: never; Returns: boolean }
      reabrir_mes: {
        Args: { p_company_id: string; p_mes: string; p_motivo: string }
        Returns: undefined
      }
      registrar_ambiente: {
        Args: { p_functions_url: string }
        Returns: undefined
      }
      resolver_canal_stripe_unico: {
        Args: { p_company_id: string }
        Returns: string
      }
      rotate_contaazul_refresh_token: {
        Args: { p_company_id: string; p_refresh_token: string }
        Returns: undefined
      }
      set_contaazul_credentials: {
        Args: {
          p_client_id: string
          p_client_secret: string
          p_company_id: string
          p_refresh_token: string
        }
        Returns: undefined
      }
      set_focus_token: {
        Args: { p_company_id: string; p_environment: string; p_token: string }
        Returns: undefined
      }
      set_pluggy_credentials: {
        Args: {
          p_client_id: string
          p_client_secret: string
          p_company_id: string
        }
        Returns: undefined
      }
      set_stripe_credentials: {
        Args: {
          p_apelido: string
          p_company_id: string
          p_mode: string
          p_publishable_key: string
          p_secret_key: string
          p_webhook_secret: string
        }
        Returns: string
      }
      sou_dono_da_plataforma: { Args: never; Returns: boolean }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
