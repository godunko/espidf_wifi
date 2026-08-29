--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.WiFi is

   ------------------------------
   -- WIFI_INIT_CONFIG_DEFAULT --
   ------------------------------

   function WIFI_INIT_CONFIG_DEFAULT return wifi_init_config_t is

      procedure Internal (Config : out wifi_init_config_t)
        with Import, Convention => C,
             External_Name => "__ada_WIFI_INIT_CONFIG_DEFAULT";

   begin
      return Result : wifi_init_config_t do
         Internal (Result);
      end return;
   end WIFI_INIT_CONFIG_DEFAULT;

end ESPIDF.WiFi;
