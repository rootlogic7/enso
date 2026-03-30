# home/desktop/waybar.nix
{ config, pkgs, lib, ... }:

{
  options.horizon.desktop.waybar.modules = lib.mkOption {
    type = lib.types.attrs;
    description = "Zentrale Definition aller Waybar-Module für Horizon";
    default = {
      # --- 1. Special Workspaces (Statisch) ---
      # --- 1a. Special Workspace: System ---
      "hyprland/workspaces#system" = { 
        format = "{icon}"; 
        on-click = "activate"; 
        persistent-workspaces = {
          "System" = [];
        };
        ignore-workspaces = [ "Server" "^[0-9]+$" ]; 
        format-icons = { 
          "System" = ""; 
        }; 
      };

      # --- 1b. Special Workspace: Server ---
      "hyprland/workspaces#server" = { 
        format = "{icon}"; 
        on-click = "activate"; 
        persistent-workspaces = {
          "Server" = [];
        };
        ignore-workspaces = [ "System" "^[0-9]+$" ]; 
        format-icons = { 
          "Server" = "󰒋"; 
        }; 
      };

      # --- 2. Regular Workspaces ---
      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
        ignore-workspaces = [ "System" "Server" ];
        format-icons = { 
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          "default" = "〇";
        };
      };

      # --- 3. User / Host Context Pille ---
      "custom/context" = {
        return-type = "json";
        interval = 1; 
        
        exec = let
          jq = "${pkgs.jq}/bin/jq";
        in pkgs.writeShellScript "waybar-context" ''
          active=$(hyprctl activewindow -j 2>/dev/null)
          
          # Wenn gar kein Fenster offen ist
          if [ "$active" = "{}" ] || [ -z "$active" ]; then
            echo '{"text": "haku  '$(hostname)'", "class": "local"}'
            exit 0
          fi
          
          # --- NEU: Multi-Monitor Filter ---
          # Welchen Monitor-Index hat das aktive Fenster?
          mon_id=$(echo "$active" | ${jq} -r '.monitor')
          # Wie heißt dieser Monitor in Hyprland (z.B. DP-6)?
          mon_name=$(hyprctl monitors -j | ${jq} -r '.[] | select(.id == '"$mon_id"') | .name')
          
          # Wenn Waybar uns seinen Namen verrät und das Fenster woanders ist:
          if [ -n "$WAYBAR_OUTPUT_NAME" ] && [ "$mon_name" != "$WAYBAR_OUTPUT_NAME" ]; then
            # Auf dem inaktiven Monitor zeigen wir einfach den lokalen Basis-Zustand
            echo '{"text": "haku  '$(hostname)'", "class": "local"}'
            exit 0
          fi
          
          title=$(echo "$active" | ${jq} -r '.title')
          
          # --- Fall 1: Die klassische "user@host" Anzeige ---
          if [[ "$title" =~ ([a-zA-Z0-9_-]+)@([a-zA-Z0-9_.-]+) ]]; then
            user="''${BASH_REMATCH[1]}"
            host="''${BASH_REMATCH[2]}"
            
            if [ "$host" != "$(hostname)" ]; then
              echo '{"text": "'"$user"' 󰒋 '"$host"'", "class": "ssh"}'
              exit 0
            fi
          fi
          
          # --- Fall 2: Lokaler SSH-Befehl ---
          if [[ "$title" =~ (\>|[[:space:]]|^)ssh([[:space:]]+([^[:space:]]+))? ]]; then
            target="''${BASH_REMATCH[3]}"
            if [ -n "$target" ]; then
              if [[ "$target" =~ ([a-zA-Z0-9_-]+)@([a-zA-Z0-9_.-]+) ]]; then
                echo '{"text": "''${BASH_REMATCH[1]} 󰒋 ''${BASH_REMATCH[2]}", "class": "ssh"}'
              else
                echo '{"text": "ssh 󰒋 '"$target"'", "class": "ssh"}'
              fi
            else
              echo '{"text": "ssh 󰒋 session", "class": "ssh"}'
            fi
            exit 0
          fi
          
          # --- Fallback: Normales lokales Fenster ---
          echo '{"text": "haku  '$(hostname)'", "class": "local"}'
        '';
      };

      # --- 4. Active Window Title ---
      "hyprland/window" = {
        format = "󰴈 |{title}";
        max-length = 60;
        separate-outputs = true;
      };

      # --- 5. Display Mode Indikator ---
      "custom/display_mode" = {
        return-type = "json";
        interval = 2;
        
        exec = pkgs.writeShellScript "waybar-display-mode" ''
          monitors=$(hyprctl monitors -j)
          
          has_dp=$(echo "$monitors" | grep -q '"name": "DP-6"' && echo "yes" || echo "no")
          has_edp=$(echo "$monitors" | grep -q '"name": "eDP-1"' && echo "yes" || echo "no")

          if [ "$has_dp" = "yes" ] && [ "$has_edp" = "yes" ]; then
            # Szenario B: Docked (Laptop + Externer Monitor)
            echo '{"text": "󰹑", "tooltip": "Docked (Dual Screen)", "class": "docked"}'
            
          elif [ "$has_dp" = "yes" ] && [ "$has_edp" = "no" ]; then
            # Szenario C: Docked-Only (Laptop ist zu, nur Externer Monitor)
            echo '{"text": "󰍹", "tooltip": "Docked-Only", "class": "docked-only"}'
            
          else
            # Szenario A: Portable (Nur Laptop)
            echo '{"text": "", "tooltip": "Portable", "class": "portable"}'
          fi
        '';
      };

      "clock" = { format = " {:%H:%M}"; tooltip-format = "<tt>{calendar}</tt>"; };
      "idle_inhibitor" = { format = "{icon}"; format-icons = { activated = ""; deactivated = ""; }; };
      "tray" = { icon-size = 14; spacing = 6; };
      "custom/power" = { format = "⏻"; on-click = "wlogout"; };
      "network" = { format-wifi = " {essid}"; format-ethernet = "󰈀 LAN"; format-disconnected = "⚠ Offline"; };
      "cpu" = { format = " {usage}%"; };
      "memory" = { format = " {percentage}%"; };
      "backlight" = { format = "{icon} {percent}%"; format-icons = ["󰃞" "󰃟" "󰃠"]; };
      "pulseaudio" = { format = "{icon} {volume}%"; format-muted = " Muted"; format-icons = { headphone = ""; default = ["" ""]; }; };
      "battery" = { states = { warning = 30; critical = 15; }; format = "{icon} {capacity}%"; format-charging = " {capacity}%"; format-icons = ["" "" "" "" ""]; };
    };
  };

  config = {
    programs.waybar = {
      enable = true;
      # Überlässt Systemd das Starten/Stoppen von Waybar passend zu Hyprland
      systemd.enable = true; 
    };
  };
}
