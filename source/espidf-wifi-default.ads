--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.NETIF;

package ESPIDF.WiFi.Default is

   function esp_netif_create_default_wifi_ap
     return ESPIDF.NETIF.esp_netif_t_ptr
       with Import, Convention => C,
            External_Name => "esp_netif_create_default_wifi_ap";
   --  Creates default WIFI AP. In case of any init error this API aborts.
   --
   --  Note: The API creates esp_netif object with default WiFi access point
   --  config, attaches the netif to wifi and registers wifi handlers to the
   --  default event loop. This API uses `assert` to check for potential
   --  errors, so it could abort the program. (Note that the default event
   --  loop needs to be created prior to calling this API)
   --  @return Pointer to esp-netif instance

   function esp_netif_create_default_wifi_sta
     return ESPIDF.NETIF.esp_netif_t_ptr
       with Import, Convention => C,
            External_Name => "esp_netif_create_default_wifi_sta";
   --  Creates default WIFI STA. In case of any init error this API aborts.
   --
   --  Note: The API creates esp_netif object with default WiFi station
   --  config, attaches the netif to wifi and registers wifi handlers to the
   --  default event loop. This API uses `assert` to check for potential
   --  errors, so it could abort the program. (Note that the default event
   --  loop needs to be created prior to calling this API)
   --  @return Pointer to esp-netif instance

   procedure esp_netif_destroy_default_wifi
     (esp_netif : in out ESPIDF.NETIF.esp_netif_t_ptr);
   --  Destroys default WIFI netif created with
   --  `esp_netif_create_default_wifi_ap`/`esp_netif_create_default_wifi_sta`
   --  API.
   --
   --  Note: This API unregisters wifi handlers and detaches the created
   --  object from the wifi. (this function is a no-operation if `esp_netif`
   --  is null)
   --  @param esp_netif
   --    Object to detach from WiFi and destroy. It is reset to null value.

end ESPIDF.WiFi.Default;
