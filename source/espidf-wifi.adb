--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.WiFi is

   -------------------
   -- esp_wifi_init --
   -------------------

   procedure esp_wifi_init (config : wifi_init_config_t) is
   begin
      ESPIDF.Ada_ESP_Check_Error (esp_wifi_init (config));
   end esp_wifi_init;

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

end ESPIDF.WiFi;
