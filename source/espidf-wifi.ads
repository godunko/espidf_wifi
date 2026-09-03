--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;
pragma Extensions_Allowed (On);
--  Aspect `Finalizable` is used to initialize objects automaically

private with System.Storage_Elements;

with ESPIDF.C_Strings;
with ESPIDF.Event;

package ESPIDF.WiFi is

   type wifi_mode_t is
     (WIFI_MODE_NULL,
      WIFI_MODE_STA,
      WIFI_MODE_AP,
      WIFI_MODE_APSTA,
      WIFI_MODE_NAN) with Convention => C;

   type wifi_interface_t is
     (WIFI_IF_STA,
      WIFI_IF_AP,
      WIFI_IF_NAN) with Convention => C;

   type wifi_init_config_t is limited private;
   --  Objects initialized using WIFI_INIT_CONFIG_DEFAULT macro automatically.

   procedure Set_nvs_enable
     (cfg : in out wifi_init_config_t; To : Boolean);

   type wifi_auth_mode_t is
     (WIFI_AUTH_OPEN,
      WIFI_AUTH_WEP,
      WIFI_AUTH_WPA_PSK,
      WIFI_AUTH_WPA2_PSK,
      WIFI_AUTH_WPA_WPA2_PSK,
      WIFI_AUTH_ENTERPRISE,
      WIFI_AUTH_WPA3_PSK,
      WIFI_AUTH_WPA2_WPA3_PSK,
      WIFI_AUTH_WAPI_PSK,
      WIFI_AUTH_OWE,
      WIFI_AUTH_WPA3_ENT_192,
      WIFI_AUTH_DUMMY_1,
      WIFI_AUTH_DUMMY_2,
      WIFI_AUTH_DPP,
      WIFI_AUTH_WPA3_ENTERPRISE,
      WIFI_AUTH_WPA2_WPA3_ENTERPRISE,
      WIFI_AUTH_WPA_ENTERPRISE) with Convention => C;
   function WIFI_AUTH_WPA2_ENTERPRISE return wifi_auth_mode_t is
     (WIFI_AUTH_ENTERPRISE);

   ------------------------------------------------
   --  `wifi_config_t` is split into STA/AP/NAN  --
   ------------------------------------------------

   type wifi_ap_config_t is limited private;

   procedure Set_ssid
     (Self : in out wifi_ap_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 33;

   procedure Set_password
     (Self : in out wifi_ap_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 65;

   type wifi_sta_config_t is limited private;

   procedure Set_ssid
     (Self : in out wifi_sta_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 33;

   procedure Set_password
     (Self : in out wifi_sta_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 65;

   procedure Set_threshold_authmode
     (Self : in out wifi_sta_config_t;
      To   : wifi_auth_mode_t);

   WIFI_EVENT : constant ESPIDF.Event.esp_event_base_t
     with Import, Convention => C, External_Name => "WIFI_EVENT";

   type wifi_event_t is new int32_t;

   WIFI_EVENT_WIFI_READY                 : constant wifi_event_t := 0;
   WIFI_EVENT_SCAN_DONE                  : constant wifi_event_t := 1;
   WIFI_EVENT_STA_START                  : constant wifi_event_t := 2;
   WIFI_EVENT_STA_STOP                   : constant wifi_event_t := 3;
   WIFI_EVENT_STA_CONNECTED              : constant wifi_event_t := 4;
   WIFI_EVENT_STA_DISCONNECTED           : constant wifi_event_t := 5;
   WIFI_EVENT_STA_AUTHMODE_CHANGE        : constant wifi_event_t := 6;
   WIFI_EVENT_STA_WPS_ER_SUCCESS         : constant wifi_event_t := 7;
   WIFI_EVENT_STA_WPS_ER_FAILED          : constant wifi_event_t := 8;
   WIFI_EVENT_STA_WPS_ER_TIMEOUT         : constant wifi_event_t := 9;
   WIFI_EVENT_STA_WPS_ER_PIN             : constant wifi_event_t := 10;
   WIFI_EVENT_STA_WPS_ER_PBC_OVERLAP     : constant wifi_event_t := 11;
   WIFI_EVENT_AP_START                   : constant wifi_event_t := 12;
   WIFI_EVENT_AP_STOP                    : constant wifi_event_t := 13;
   WIFI_EVENT_AP_STACONNECTED            : constant wifi_event_t := 14;
   WIFI_EVENT_AP_STADISCONNECTED         : constant wifi_event_t := 15;
   WIFI_EVENT_AP_PROBEREQRECVED          : constant wifi_event_t := 16;
   WIFI_EVENT_FTM_REPORT                 : constant wifi_event_t := 17;
   WIFI_EVENT_STA_BSS_RSSI_LOW           : constant wifi_event_t := 18;
   WIFI_EVENT_ACTION_TX_STATUS           : constant wifi_event_t := 19;
   WIFI_EVENT_ROC_DONE                   : constant wifi_event_t := 20;
   WIFI_EVENT_STA_BEACON_TIMEOUT         : constant wifi_event_t := 21;
   WIFI_EVENT_CONNECTIONLESS_MODULE_WAKE_INTERVAL_START :
                                           constant wifi_event_t := 22;
   WIFI_EVENT_AP_WPS_RG_SUCCESS          : constant wifi_event_t := 23;
   WIFI_EVENT_AP_WPS_RG_FAILED           : constant wifi_event_t := 24;
   WIFI_EVENT_AP_WPS_RG_TIMEOUT          : constant wifi_event_t := 25;
   WIFI_EVENT_AP_WPS_RG_PIN              : constant wifi_event_t := 26;
   WIFI_EVENT_AP_WPS_RG_PBC_OVERLAP      : constant wifi_event_t := 27;
   WIFI_EVENT_ITWT_SETUP                 : constant wifi_event_t := 28;
   WIFI_EVENT_ITWT_TEARDOWN              : constant wifi_event_t := 29;
   WIFI_EVENT_ITWT_PROBE                 : constant wifi_event_t := 30;
   WIFI_EVENT_ITWT_SUSPEND               : constant wifi_event_t := 31;
   WIFI_EVENT_TWT_WAKEUP                 : constant wifi_event_t := 32;
   WIFI_EVENT_BTWT_SETUP                 : constant wifi_event_t := 33;
   WIFI_EVENT_BTWT_TEARDOWN              : constant wifi_event_t := 34;
   WIFI_EVENT_NAN_SYNC_STARTED           : constant wifi_event_t := 35;
   WIFI_EVENT_NAN_SYNC_STOPPED           : constant wifi_event_t := 36;
   WIFI_EVENT_NAN_SVC_MATCH              : constant wifi_event_t := 37;
   WIFI_EVENT_NAN_REPLIED                : constant wifi_event_t := 38;
   WIFI_EVENT_NAN_RECEIVE                : constant wifi_event_t := 39;
   WIFI_EVENT_NDP_INDICATION             : constant wifi_event_t := 40;
   WIFI_EVENT_NDP_CONFIRM                : constant wifi_event_t := 41;
   WIFI_EVENT_NDP_TERMINATED             : constant wifi_event_t := 42;
   WIFI_EVENT_HOME_CHANNEL_CHANGE        : constant wifi_event_t := 43;
   WIFI_EVENT_STA_NEIGHBOR_REP           : constant wifi_event_t := 44;
   WIFI_EVENT_AP_WRONG_PASSWORD          : constant wifi_event_t := 45;
   WIFI_EVENT_STA_BEACON_OFFSET_UNSTABLE : constant wifi_event_t := 46;
   WIFI_EVENT_DPP_URI_READY              : constant wifi_event_t := 47;
   WIFI_EVENT_DPP_CFG_RECVD              : constant wifi_event_t := 48;
   WIFI_EVENT_DPP_FAILED                 : constant wifi_event_t := 49;

   function esp_wifi_init (config : wifi_init_config_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_init";

   procedure esp_wifi_init (config : wifi_init_config_t);

   function esp_wifi_set_mode (mode : wifi_mode_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_set_mode";

   procedure esp_wifi_set_mode (mode : wifi_mode_t);

   function esp_wifi_set_config
     (iface : wifi_interface_t;
      conf  : in out wifi_sta_config_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_set_config";

   procedure esp_wifi_set_config
     (iface : wifi_interface_t;
      conf  : in out wifi_sta_config_t);

   function esp_wifi_start return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_start";

   procedure esp_wifi_start;

   function esp_wifi_connect return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_connect";

   procedure esp_wifi_connect;

private

   sizeof_wifi_init_config_t : constant int
      with Import, Convention => C,
           Link_Name => "__ada_sizeof_wifi_init_config_t";

   type wifi_init_config_t_Storage is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count
               (sizeof_wifi_init_config_t)) with Convention => C;

   procedure Initialize (Self : in out wifi_init_config_t);

   type wifi_init_config_t is record
      Storage : wifi_init_config_t_Storage := (others => 0);
   end record
     with Convention => C,
          Finalizable =>
            (Initialize           => Initialize,
             Relaxed_Finalization => True);

   sizeof_wifi_config_t : constant int
      with Import, Convention => C,
           Link_Name => "__ada_sizeof_wifi_config_t";

   type wifi_ap_config_t is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count (sizeof_wifi_config_t))
       with Convention => C, Default_Component_Value => 0;

   type wifi_sta_config_t is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count (sizeof_wifi_config_t))
       with Convention => C, Default_Component_Value => 0;

end ESPIDF.WiFi;
