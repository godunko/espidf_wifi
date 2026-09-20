--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body ESPIDF.WiFi.Default is

   ------------------------------------
   -- esp_netif_destroy_default_wifi --
   ------------------------------------

   procedure esp_netif_destroy_default_wifi
     (esp_netif : in out ESPIDF.NETIF.esp_netif_t_ptr)
   is
      procedure Imported
        (esp_netif : ESPIDF.NETIF.esp_netif_t_ptr)
        with Import, Convention => C,
             External_Name => "esp_netif_destroy_default_wifi";

   begin
      Imported (esp_netif);
      esp_netif := null;
   end esp_netif_destroy_default_wifi;

end ESPIDF.WiFi.Default;
