--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.WiFi is

   ----------------------
   -- esp_wifi_connect --
   ----------------------

   procedure esp_wifi_connect is
   begin
      Ada_ESP_Check_Error (esp_wifi_connect);
   end esp_wifi_connect;

   -------------------
   -- esp_wifi_init --
   -------------------

   procedure esp_wifi_init (config : wifi_init_config_t) is
   begin
      Ada_ESP_Check_Error (esp_wifi_init (config));
   end esp_wifi_init;

   -------------------------
   -- esp_wifi_set_config --
   -------------------------

   procedure esp_wifi_set_config
     (iface : wifi_interface_t;
      conf  : in out wifi_config_t) is
   begin
      Ada_ESP_Check_Error (esp_wifi_set_config (iface, conf));
   end esp_wifi_set_config;

   -----------------------
   -- esp_wifi_set_mode --
   -----------------------

   procedure esp_wifi_set_mode (mode : wifi_mode_t) is
   begin
      Ada_ESP_Check_Error (esp_wifi_set_mode (mode));
   end esp_wifi_set_mode;

   --------------------
   -- esp_wifi_start --
   --------------------

   procedure esp_wifi_start is
   begin
      Ada_ESP_Check_Error (esp_wifi_start);
   end esp_wifi_start;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Self : in out wifi_init_config_t) is

      procedure Imported (config : out wifi_init_config_t)
        with Import, Convention => C,
             External_Name => "__ada_WIFI_INIT_CONFIG_DEFAULT";

   begin
      Imported (Self);
   end Initialize;

   ---------------------
   -- Set_nvs_disable --
   ---------------------

   procedure Set_nvs_enable
     (cfg : in out wifi_init_config_t; To : Boolean)
   is
      procedure Imported
        (cfg : in out wifi_init_config_t; To : Interfaces.C.C_bool)
        with Import, Convention => C,
             External_Name => "__ada_Set_wifi_init_config_t_nvs_enable";

   begin
      Imported (cfg, Interfaces.C.C_bool (To));
   end Set_nvs_enable;

   ----------------------
   -- Set_sta_password --
   ----------------------

   procedure Set_sta_password
     (Self : in out wifi_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
   is
      procedure Imported
        (cfg  : in out wifi_config_t;
         pwd  : not null ESPIDF.C_Strings.const_char_ptr;
         len  : Integer)
        with Import, Convention => C,
             External_Name => "__ada_Set_wifi_config_t_sta_password";

   begin
      Imported (Self, ESPIDF.C_Strings.As_const_char_ptr (To), To'Length - 1);
   end Set_sta_password;

   ------------------
   -- Set_sta_ssid --
   ------------------

   procedure Set_sta_ssid
     (Self : in out wifi_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
   is
      procedure Imported
        (cfg  : in out wifi_config_t;
         ssid : not null ESPIDF.C_Strings.const_char_ptr;
         len  : Integer)
        with Import, Convention => C,
             External_Name => "__ada_Set_wifi_config_t_sta_ssid";

   begin
      Imported (Self, ESPIDF.C_Strings.As_const_char_ptr (To), To'Length - 1);
   end Set_sta_ssid;

end ESPIDF.WiFi;
