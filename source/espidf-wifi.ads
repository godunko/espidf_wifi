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

   type wifi_config_t is limited private;

   procedure Set_sta_ssid
     (Self : in out wifi_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 33;

   WIFI_EVENT : constant ESPIDF.Event.esp_event_base_t
     with Import, Convention => C, External_Name => "WIFI_EVENT";

   WIFI_EVENT_WIFI_READY                 : constant int32_t := 0;
   WIFI_EVENT_SCAN_DONE                  : constant int32_t := 1;
   WIFI_EVENT_STA_START                  : constant int32_t := 2;
   WIFI_EVENT_STA_STOP                   : constant int32_t := 3;
   WIFI_EVENT_STA_CONNECTED              : constant int32_t := 4;
   WIFI_EVENT_STA_DISCONNECTED           : constant int32_t := 5;
   WIFI_EVENT_STA_AUTHMODE_CHANGE        : constant int32_t := 6;
   WIFI_EVENT_STA_WPS_ER_SUCCESS         : constant int32_t := 7;
   WIFI_EVENT_STA_WPS_ER_FAILED          : constant int32_t := 8;
   WIFI_EVENT_STA_WPS_ER_TIMEOUT         : constant int32_t := 9;
   WIFI_EVENT_STA_WPS_ER_PIN             : constant int32_t := 10;
   WIFI_EVENT_STA_WPS_ER_PBC_OVERLAP     : constant int32_t := 11;
   WIFI_EVENT_AP_START                   : constant int32_t := 12;
   WIFI_EVENT_AP_STOP                    : constant int32_t := 13;
   WIFI_EVENT_AP_STACONNECTED            : constant int32_t := 14;
   WIFI_EVENT_AP_STADISCONNECTED         : constant int32_t := 15;
   WIFI_EVENT_AP_PROBEREQRECVED          : constant int32_t := 16;
   WIFI_EVENT_FTM_REPORT                 : constant int32_t := 17;
   WIFI_EVENT_STA_BSS_RSSI_LOW           : constant int32_t := 18;
   WIFI_EVENT_ACTION_TX_STATUS           : constant int32_t := 19;
   WIFI_EVENT_ROC_DONE                   : constant int32_t := 20;
   WIFI_EVENT_STA_BEACON_TIMEOUT         : constant int32_t := 21;
   WIFI_EVENT_CONNECTIONLESS_MODULE_WAKE_INTERVAL_START :
                                           constant int32_t := 22;
   WIFI_EVENT_AP_WPS_RG_SUCCESS          : constant int32_t := 23;
   WIFI_EVENT_AP_WPS_RG_FAILED           : constant int32_t := 24;
   WIFI_EVENT_AP_WPS_RG_TIMEOUT          : constant int32_t := 25;
   WIFI_EVENT_AP_WPS_RG_PIN              : constant int32_t := 26;
   WIFI_EVENT_AP_WPS_RG_PBC_OVERLAP      : constant int32_t := 27;
   WIFI_EVENT_ITWT_SETUP                 : constant int32_t := 28;
   WIFI_EVENT_ITWT_TEARDOWN              : constant int32_t := 29;
   WIFI_EVENT_ITWT_PROBE                 : constant int32_t := 30;
   WIFI_EVENT_ITWT_SUSPEND               : constant int32_t := 31;
   WIFI_EVENT_TWT_WAKEUP                 : constant int32_t := 32;
   WIFI_EVENT_BTWT_SETUP                 : constant int32_t := 33;
   WIFI_EVENT_BTWT_TEARDOWN              : constant int32_t := 34;
   WIFI_EVENT_NAN_SYNC_STARTED           : constant int32_t := 35;
   WIFI_EVENT_NAN_SYNC_STOPPED           : constant int32_t := 36;
   WIFI_EVENT_NAN_SVC_MATCH              : constant int32_t := 37;
   WIFI_EVENT_NAN_REPLIED                : constant int32_t := 38;
   WIFI_EVENT_NAN_RECEIVE                : constant int32_t := 39;
   WIFI_EVENT_NDP_INDICATION             : constant int32_t := 40;
   WIFI_EVENT_NDP_CONFIRM                : constant int32_t := 41;
   WIFI_EVENT_NDP_TERMINATED             : constant int32_t := 42;
   WIFI_EVENT_HOME_CHANNEL_CHANGE        : constant int32_t := 43;
   WIFI_EVENT_STA_NEIGHBOR_REP           : constant int32_t := 44;
   WIFI_EVENT_AP_WRONG_PASSWORD          : constant int32_t := 45;
   WIFI_EVENT_STA_BEACON_OFFSET_UNSTABLE : constant int32_t := 46;
   WIFI_EVENT_DPP_URI_READY              : constant int32_t := 47;
   WIFI_EVENT_DPP_CFG_RECVD              : constant int32_t := 48;
   WIFI_EVENT_DPP_FAILED                 : constant int32_t := 49;

   function esp_wifi_init (config : wifi_init_config_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_init";

   procedure esp_wifi_init (config : wifi_init_config_t);

   function esp_wifi_set_mode (mode : wifi_mode_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_set_mode";

   procedure esp_wifi_set_mode (mode : wifi_mode_t);

   function esp_wifi_set_config
     (iface : wifi_interface_t;
      conf  : in out wifi_config_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_set_config";

   procedure esp_wifi_set_config
     (iface : wifi_interface_t;
      conf  : in out wifi_config_t);

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

   type wifi_config_t is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count (sizeof_wifi_config_t))
       with Convention => C, Default_Component_Value => 0;

end ESPIDF.WiFi;
