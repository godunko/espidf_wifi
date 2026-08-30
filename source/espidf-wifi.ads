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
