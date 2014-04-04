require 'singleton'

module Vindicia

  API_CLASSES = {
    "3.5" => {
      :account=>[:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history],
      :activity=>[:record],
      :address=>[:update, :fetch_by_vid],
      :all_data_types=>[:get_vindicia], 
      :all_symc_data_types=>[:get_vindicia], 
      :auto_bill=>[:update, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :finalize_pay_pal_auth],
      :billing_plan=>[:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id],
      :chargeback=>[:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report], 
      :diagnostic=>[:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment],
      :electronic_signature=>[:sign, :get_signature_block],
      :email_template=>[:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement=>[:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card=>[:status_inquiry, :reverse],
      :metric_statistics=>[:report],
      :payment_method=>[:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider=>[:update, :fetch_by_vid],
      :product=>[:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :refund=>[:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :symantec=>[:add_auto_bill_item, :cancel_auto_bill, :cancel_pending_ar_txns, :delay_bill, :dispute_bill, :refund_ab_txns, :update_abs_account, :update_ab_product, :update_bp, :update_bp_and_catch_up_billing, :validate_bp, :fetch_b_ps_by_customer_guid, :lookup_transaction, :disable_billing_profile, :fetch_captured_transactions, :report_order_exception],
      :token=>[:update, :fetch],
      :transaction=>[:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_search_page, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    },
    "3.6" => {
      :account=>[:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :add_children, :remove_children, :fetch_family, :transfer_credit],
      :activity=>[:record],
      :address=>[:update, :fetch_by_vid],
      :all_data_types=>[:get_vindicia],
      :all_symc_data_types=>[:get_vindicia],
      :auto_bill=>[:update, :upgrade, :fetch_upgrade_history_by_merchant_auto_bill_id, :fetch_upgrade_history_by_vid, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :finalize_pay_pal_auth],
      :billing_plan=>[:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id],
      :chargeback=>[:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report],
      :diagnostic=>[:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment, :useless_use_of_diagnostic_object],
      :electronic_signature=>[:sign, :get_signature_block],
      :email_template=>[:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement=>[:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card=>[:status_inquiry, :reverse],
      :metric_statistics=>[:report],
      :payment_method=>[:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider=>[:update, :fetch_by_vid],
      :product=>[:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :refund=>[:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :symantec=>[:add_auto_bill_item, :cancel_auto_bill, :cancel_pending_ar_txns, :delay_bill, :dispute_bill, :refund_ab_txns, :update_abs_account, :update_ab_product, :update_bp, :update_bp_and_catch_up_billing, :validate_bp, :fetch_b_ps_by_customer_guid, :lookup_transaction, :disable_billing_profile, :fetch_captured_transactions, :report_order_exception],
      :token=>[:update, :fetch],
      :transaction=>[:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_search_page, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    },
    "3.7" => {
      :account => [:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :add_children, :remove_children, :fetch_family, :transfer_credit, :make_payment, :reverse_payment, :is_entitled, :grant_entitlement, :revoke_entitlement, :extend_entitlement_to_date, :extend_entitlement_by_interval],
      :activity => [:record],
      :address => [:update, :fetch_by_vid],
      :all_data_types => [:get_vindicia],
      :all_symc_data_types => [:get_vindicia],
      :auto_bill => [:update, :upgrade, :fetch_upgrade_history_by_merchant_auto_bill_id, :fetch_upgrade_history_by_vid, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :finalize_pay_pal_auth, :add_product, :remove_product, :add_charge, :make_payment, :reverse_payment, :fetch_invoice, :fetch_invoice_numbers, :write_off_invoice],
      :billing_plan => [:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id],
      :chargeback => [:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report],
      :diagnostic => [:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment, :useless_use_of_diagnostic_object],
      :electronic_signature => [:sign, :get_signature_block],
      :email_template => [:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement => [:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card => [:status_inquiry, :reverse],
      :metric_statistics => [:report],
      :payment_method => [:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider => [:update, :fetch_by_vid],
      :product => [:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :refund => [:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :symantec => [:add_auto_bill_item, :cancel_auto_bill, :cancel_pending_ar_txns, :delay_bill, :dispute_bill, :refund_ab_txns, :update_abs_account, :update_ab_product, :update_bp, :update_bp_and_catch_up_billing, :validate_bp, :fetch_b_ps_by_customer_guid, :lookup_transaction, :disable_billing_profile, :fetch_captured_transactions, :report_order_exception],
      :token => [:update, :fetch],
      :transaction => [:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_search_page, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    },
    "3.8" => {
      :account => [:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :add_children, :remove_children, :fetch_family, :transfer_credit, :make_payment, :reverse_payment, :is_entitled, :grant_entitlement, :revoke_entitlement, :extend_entitlement_to_date, :extend_entitlement_by_interval],
      :activity => [:record],
      :address => [:update, :fetch_by_vid],
      :all_data_types => [:get_vindicia],
      :all_symc_data_types => [:get_vindicia],
      :auto_bill => [:update, :upgrade, :add_campaign, :fetch_upgrade_history_by_merchant_auto_bill_id, :fetch_upgrade_history_by_vid, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :finalize_pay_pal_auth, :add_product, :remove_product, :add_campaign_to_product, :add_charge, :make_payment, :reverse_payment, :fetch_invoice, :fetch_invoice_numbers, :write_off_invoice],
      :billing_plan => [:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id],
      :campaign => [:generate_coupon_codes, :retrieve_coupon_codes, :validate_code, :activate_code, :fetch_all_campaigns, :fetch_by_campaign_id, :fetch_by_vid, :activate_campaign, :deactivate_campaign, :cancel_campaign, :mark_all_coupons_used, :update_campaign, :create_campaign, :clone_campaign],
      :chargeback => [:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report],
      :diagnostic => [:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment, :useless_use_of_diagnostic_object],
      :electronic_signature => [:sign, :get_signature_block],
      :email_template => [:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement => [:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card => [:status_inquiry, :reverse],
      :metric_statistics => [:report],
      :payment_method => [:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider => [:update, :fetch_by_vid],
      :product => [:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :refund => [:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :symantec => [:add_auto_bill_item, :cancel_auto_bill, :cancel_pending_ar_txns, :delay_bill, :dispute_bill, :refund_ab_txns, :update_abs_account, :update_ab_product, :update_bp, :update_bp_and_catch_up_billing, :validate_bp, :fetch_b_ps_by_customer_guid, :lookup_transaction, :disable_billing_profile, :fetch_captured_transactions, :report_order_exception],
      :token => [:update, :fetch],
      :transaction => [:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_search_page, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    },
    "3.9" => {
      :account => [:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :fetch_all_credit_history, :add_children, :remove_children, :fetch_family, :transfer_credit, :make_payment, :reverse_payment, :is_entitled, :grant_entitlement, :revoke_entitlement, :extend_entitlement_to_date, :extend_entitlement_by_interval],
      :activity => [:record],
      :address => [:update, :fetch_by_vid],
      :all_data_types => [:get_vindicia],
      :all_symc_data_types => [:get_vindicia],
      :auto_bill => [:update, :upgrade, :add_campaign, :fetch_upgrade_history_by_merchant_auto_bill_id, :fetch_upgrade_history_by_vid, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :fetch_all_credit_history, :finalize_pay_pal_auth, :add_product, :remove_product, :add_campaign_to_product, :add_charge, :make_payment, :reverse_payment, :fetch_invoice, :fetch_invoice_numbers, :write_off_invoice],
      :billing_plan => [:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id],
      :campaign => [:generate_coupon_codes, :retrieve_coupon_codes, :validate_code, :activate_code, :fetch_all_campaigns, :fetch_by_campaign_id, :fetch_by_vid, :activate_campaign, :deactivate_campaign, :cancel_campaign, :mark_all_coupons_used, :update_campaign, :create_campaign, :clone_campaign],
      :chargeback => [:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report],
      :diagnostic => [:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment, :useless_use_of_diagnostic_object],
      :electronic_signature => [:sign, :get_signature_block],
      :email_template => [:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement => [:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card => [:status_inquiry, :reverse],
      :name_value_pair => [:fetch_name_value_names, :fetch_name_value_types],
      :payment_method => [:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider => [:update, :fetch_by_vid],
      :product => [:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :refund => [:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :symantec => [:add_auto_bill_item, :cancel_auto_bill, :cancel_pending_ar_txns, :delay_bill, :dispute_bill, :refund_ab_txns, :update_abs_account, :update_ab_product, :update_bp, :update_bp_and_catch_up_billing, :validate_bp, :fetch_b_ps_by_customer_guid, :lookup_transaction, :disable_billing_profile, :fetch_captured_transactions, :report_order_exception],
      :token => [:update, :fetch],
      :transaction => [:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_search_page, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    },
    "4.0" => {
      :account => [:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :fetch_all_credit_history, :add_children, :remove_children, :fetch_family, :transfer_credit, :make_payment, :reverse_payment, :is_entitled, :grant_entitlement, :revoke_entitlement, :extend_entitlement_to_date, :extend_entitlement_by_interval],
      :activity => [:record],
      :address => [:update, :fetch_by_vid],
      :all_data_types => [:get_vindicia],
      :auto_bill => [:update, :upgrade, :add_campaign, :fetch_upgrade_history_by_merchant_auto_bill_id, :fetch_upgrade_history_by_vid, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :fetch_future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :fetch_all_credit_history, :finalize_pay_pal_auth, :add_product, :remove_product, :add_campaign_to_product, :add_charge, :make_payment, :reverse_payment, :fetch_invoice, :fetch_invoice_numbers, :write_off_invoice],
      :billing_plan => [:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id],
      :campaign => [:generate_coupon_codes, :retrieve_coupon_codes, :validate_code, :activate_code, :fetch_all_campaigns, :fetch_by_campaign_id, :fetch_by_vid, :activate_campaign, :deactivate_campaign, :cancel_campaign, :mark_all_coupons_used, :update_campaign, :create_campaign, :clone_campaign],
      :chargeback => [:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report],
      :diagnostic => [:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment, :useless_use_of_diagnostic_object],
      :electronic_signature => [:sign, :get_signature_block],
      :email_template => [:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement => [:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card => [:status_inquiry, :reverse],
      :name_value_pair => [:fetch_name_value_names, :fetch_name_value_types],
      :payment_method => [:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider => [:fetch_by_name, :data_request],
      :product => [:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :rate_plan => [:update, :fetch_by_merchant_rate_plan_id, :fetch_by_vid, :record_event, :reverse_event, :deduct_event, :fetch_unbilled_rated_units_total, :fetch_unbilled_events, :fetch_events, :fetch_event_by_id, :fetch_event_by_vid],
      :refund => [:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :token => [:update, :fetch],
      :transaction => [:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_search_page, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth, :finalize_boku_auth_capture],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    },
    "4.2" => {
      :account => [:update, :stop_auto_billing, :update_payment_method, :fetch_by_merchant_account_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_payment_method, :token_balance, :token_transaction, :increment_tokens, :decrement_tokens, :transfer, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :fetch_all_credit_history, :add_children, :remove_children, :fetch_family, :transfer_credit, :make_payment, :reverse_payment, :is_entitled, :grant_entitlement, :revoke_entitlement, :extend_entitlement_to_date, :extend_entitlement_by_interval],
      :activity => [:record],
      :address => [:update, :fetch_by_vid],
      :all_data_types => [:get_vindicia],
      :auto_bill => [:update, :upgrade, :add_campaign, :fetch_upgrade_history_by_merchant_auto_bill_id, :fetch_upgrade_history_by_vid, :cancel, :delay_billing_to_date, :delay_billing_by_days, :change_billing_day_of_month, :fetch_by_account_and_product, :fetch_by_merchant_auto_bill_id, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_email, :fetch_by_account, :fetch_future_rebills, :fetch_delta_since, :redeem_gift_card, :grant_credit, :revoke_credit, :fetch_credit_history, :fetch_all_credit_history, :finalize_pay_pal_auth, :finalize_customer_action, :add_product, :remove_product, :add_charge, :make_payment, :reverse_payment, :fetch_invoice, :fetch_invoice_numbers, :write_off_invoice, :fetch_all_in_season, :fetch_all_off_season, :fetch_remaining_payment_details, :fetch_daily_invoice_billings],
      :billing_plan => [:update, :fetch_by_vid, :fetch_by_merchant_billing_plan_id, :fetch_by_billing_plan_status, :fetch_all, :fetch_by_merchant_entitlement_id, :fetch_all_in_season, :fetch_all_off_season],
      :campaign => [:generate_coupon_codes, :retrieve_coupon_codes, :validate_code, :activate_code, :fetch_all_campaigns, :fetch_by_campaign_id, :fetch_by_vid, :activate_campaign, :deactivate_campaign, :cancel_campaign, :mark_all_coupons_used, :update_campaign, :create_campaign, :clone_campaign],
      :chargeback => [:update, :fetch_by_vid, :fetch_by_account, :fetch_by_case_number, :fetch_by_reference_number, :fetch_by_status, :fetch_by_status_since, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :report],
      :diagnostic => [:get_hello, :put_hello, :echo_string, :echo_string_by_proxy, :get_some_mock_transactions, :put_some_mock_transactions, :echo_boolean, :echo_date_time, :echo_mock_activity_fulfillment, :useless_use_of_diagnostic_object],
      :electronic_signature => [:sign, :get_signature_block],
      :email_template => [:update, :fetch_by_vid, :fetch_by_product, :fetch_by_type, :fetch_by_type_and_version],
      :entitlement => [:fetch_by_entitlement_id_and_account, :fetch_by_account, :fetch_delta_since],
      :gift_card => [:status_inquiry, :reverse],
      :name_value_pair => [:fetch_name_value_names, :fetch_name_value_types],
      :payment_method => [:update, :fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_payment_method_id, :validate],
      :payment_provider => [:fetch_by_name, :data_request],
      :product => [:update, :fetch_by_vid, :fetch_by_merchant_product_id, :fetch_by_account, :fetch_all, :fetch_by_merchant_entitlement_id],
      :rate_plan => [:update, :fetch_by_merchant_rate_plan_id, :fetch_by_vid, :record_event, :reverse_event, :deduct_event, :fetch_unbilled_rated_units_total, :fetch_unbilled_events, :fetch_events, :fetch_event_by_id, :fetch_event_by_vid, :fetch_all],
      :refund => [:fetch_by_vid, :fetch_by_account, :fetch_by_transaction, :fetch_delta_since, :report, :perform],
      :token => [:update, :fetch],
      :transaction => [:fetch_by_vid, :fetch_by_web_session_vid, :fetch_by_account, :fetch_by_merchant_transaction_id, :fetch_delta_since, :fetch_delta, :fetch_by_autobill, :fetch_by_payment_method, :auth, :calculate_sales_tax, :capture, :cancel, :auth_capture, :report, :score, :finalize_pay_pal_auth, :finalize_boku_auth_capture, :finalize_customer_action, :address_and_sales_tax_from_pay_pal_order],
      :web_session=>[:_initialize, :finalize, :fetch_by_vid]
    }
  }

  class Configuration
    include Singleton
    
    attr_accessor :api_version, :login, :password, :endpoint, :namespace

    def initialize
      @@configured = false      
    end

    def configured!
      @@configured = true
    end
    
    def is_configured?
      @@configured
    end      
  end

  def self.config
    Configuration.instance
  end

  def self.configure
    raise 'Vindicia-api gem has already been configured. Things might get hairy if we do this again with new values.' if config.is_configured?
    yield config
    if initialize!
      config.configured!
    end
  end

  private
  
  def self.initialize!
    return false unless API_CLASSES[config.api_version]
  
    API_CLASSES[config.api_version].each_key do |vindicia_klass|
      const_set(vindicia_klass.to_s.camelize, 
        Class.new do
          include Vindicia::Model

          client do
            http.headers["Pragma"] = "no-cache"
            http.auth.ssl.verify_mode = :none # TODO set based on environment
          end

          api_version Vindicia.config.api_version
          login Vindicia.config.login
          password Vindicia.config.password

          endpoint Vindicia.config.endpoint
          namespace Vindicia.config.namespace

          actions *API_CLASSES[Vindicia.config.api_version][vindicia_klass]
        end
      )
    end
  end
end
