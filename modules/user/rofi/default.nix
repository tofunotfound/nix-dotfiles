{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules;
in

{

  options.myHomeModules.rofi.enable = lib.mkEnableOption "enable rofi";

  options.myHomeModules.rofi.dpi = lib.mkOption
  { type = lib.types.int;
    default = 200;
  };

  config = lib.mkIf cfg.rofi.enable {
    home.packages = with pkgs;
      [ util-linux playerctl ];
      #++ lib.optional (!cfg.packages.playerctl.enable) playerctl;

    programs.rofi =
    { enable = true;

      theme = lib.mkIf (!cfg.theme.catppuccin.enable) "${pkgs.rofi}/share/rofi/themes/Arc-Dark";

      settings =
      { dpi = cfg.rofi.dpi;
      };
    };

    xdg.configFile."rofi/scripts/calendar.sh" =
    { executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash

        set -u

        state_file="''${XDG_RUNTIME_DIR:-/tmp}/rofi-calendar-state"

        build_calendar() {
          local m="''${1}"
          local y="''${2}"
          local today
          local out

          if ! out=$(cal -m "''${m}" "''${y}" 2>/dev/null); then
            return 1
          fi

          if [[ "''${m}" -eq "$(date +%-m)" && "''${y}" -eq "$(date +%Y)" ]]; then
            today=$(date +%-d)
            out=$(printf '%s\n' "''${out}" | awk \
              -v day="''${today}" \
              -v tag_open="<span foreground='#ffffff' weight='bold'>" \
              -v tag_close="</span>" '
              NR <= 2 { print; next }
              {
                line = $0
                for (i = 0; i < 7; i++) {
                  pos = i * 3 + 1
                  cell = substr(line, pos, 2)
                  if (cell ~ /[0-9]/ && cell + 0 == day) {
                    line = substr(line, 1, pos - 1) tag_open cell tag_close substr(line, pos + 2)
                    break
                  }
                }
                print line
              }
            ')
          fi

          out=$(printf '%s\n' "''${out}" | awk '
            NR == 1 {
              sub(/^[[:space:]]+/, "")
              sub(/[[:space:]]+$/, "")
            }
            { print }
          ')

          printf '%s' "''${out}"
        }

        script_path=$(readlink -f "$0")

        if [[ -z "''${ROFI_RETV:-}" ]]; then
          date +%-m >"''${state_file}"
          date +%Y >>"''${state_file}"
          exec rofi -show calendar \
            -modes "calendar:''${script_path}" \
            -theme-str 'window { width: 17em; }' \
            -theme-str 'mainbox { children: [ message ]; padding: 1.2em; }' \
            -theme-str 'message { padding: 0; border: 0; }' \
            -theme-str 'textbox { horizontal-align: 0.5; }' \
            -kb-custom-1 "[43],h,[113]" \
            -kb-custom-2 "[46],l,[114]" \
            -kb-custom-3 "[19],0,[110]" \
            -kb-custom-4 "[44],j" \
            -kb-custom-5 "[45],k" \
            -kb-accept-entry "" \
            -kb-accept-custom "" \
            -kb-accept-alt "" \
            -me-accept-entry "" \
            -me-accept-custom ""
        fi

        month=$(sed -n '1p' "''${state_file}" 2>/dev/null || true)
        year=$(sed -n '2p' "''${state_file}" 2>/dev/null || true)

        if [[ -z "''${month}" || -z "''${year}" ]]; then
          month=$(date +%-m)
          year=$(date +%Y)
        fi

        case "''${ROFI_RETV:-0}" in
          10)
            if (( month == 1 )); then
              month=12
              year=$((year - 1))
            else
              month=$((month - 1))
            fi
            ;;
          11)
            if (( month == 12 )); then
              month=1
              year=$((year + 1))
            else
              month=$((month + 1))
            fi
            ;;
          12)
            month=$(date +%-m)
            year=$(date +%Y)
            ;;
          13)
            year=$((year - 1))
            ;;
          14)
            year=$((year + 1))
            ;;
        esac

        printf '%s\n%s\n' "''${month}" "''${year}" >"''${state_file}"

        calendar=$(build_calendar "''${month}" "''${year}")
        calendar=$(printf '%s\n' "''${calendar}" | awk '{ printf "%s%s", (NR > 1 ? "&#10;" : ""), $0 }')

        printf '\0use-hot-keys\x1ftrue\n'
        printf '\0message\x1f%s\n' "''${calendar}"
        printf '.\0nonselectable\x1ftrue\n'
      '';
    };

    xdg.configFile."rofi/scripts/player.sh" =
    { executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash

        set -u

        prev_icon=$'\xef\x81\x8a'
        play_icon=$'\xef\x81\x8b'
        pause_icon=$'\xef\x81\x8c'
        next_icon=$'\xef\x81\x8e'

        script_path=$(readlink -f "$0")
        sep=$'\x1f'

        truncate_text() {
          local text="''${1}"
          local max="''${2}"

          if (( ''${#text} > max )); then
            printf '%s…' "''${text:0:max-1}"
          else
            printf '%s' "''${text}"
          fi
        }

        escape_markup() {
          printf '%s' "''${1}" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
        }

        if [[ -z "''${ROFI_RETV:-}" ]]; then
          exec rofi -show player \
            -modes "player:''${script_path}" \
            -theme-str 'window { width: 26em; }' \
            -theme-str 'mainbox { children: [ message, listview ]; spacing: 0.8em; padding: 1em; }' \
            -theme-str 'message { padding: 0; border: 0; }' \
            -theme-str 'listview { border: 0; columns: 3; lines: 1; fixed-columns: true; require-input: false; spacing: 0.6em; scrollbar: false; }' \
            -theme-str 'element { padding: 0.8em; border: 0; border-radius: 0; }' \
            -theme-str 'element normal.normal { background-color: var(alternate-normal-background); text-color: var(alternate-normal-foreground); }' \
            -theme-str 'element alternate.normal { background-color: var(alternate-normal-background); text-color: var(alternate-normal-foreground); }' \
            -theme-str 'element selected.normal { background-color: var(alternate-normal-background); text-color: var(alternate-normal-foreground); }' \
            -theme-str 'element-text { horizontal-align: 0.5; background-color: transparent; }' \
            -theme-str 'element-icon { background-color: transparent; }' \
            -kb-custom-1 "[43],h,[113]" \
            -kb-custom-2 "[46],l,[114]" \
            -kb-custom-3 "[65],space" \
            -kb-custom-4 "[44],j" \
            -kb-custom-5 "[45],k" \
            -kb-accept-entry "" \
            -kb-accept-custom "" \
            -kb-accept-alt "" \
            -me-accept-entry "" \
            -me-accept-custom ""
        fi

        pl=$(for p in $(playerctl -l 2>/dev/null); do
          if [[ "$(playerctl -p "''${p}" status 2>/dev/null)" == "Playing" ]]; then
            printf '%s' "''${p}"
            break
          fi
        done)
        if [[ -z "''${pl}" ]]; then
          pl=$(playerctl -l 2>/dev/null | head -n 1)
        fi

        snapshot() {
          if [[ -z "''${pl}" ]]; then
            printf '%s%s' "''${sep}" "''${sep}"
            return 0
          fi
          playerctl -p "''${pl}" metadata \
            --format "{{status}}''${sep}{{artist}}''${sep}{{title}}" 2>/dev/null || true
        }

        pre_status=""

        if [[ "''${ROFI_RETV:-0}" == 10 || "''${ROFI_RETV:-0}" == 11 ]]; then
          IFS="''${sep}" read -r pre_status _ _ <<<"$(snapshot)"
        fi

        settle=0

        case "''${ROFI_RETV:-0}" in
          10)
            if [[ -n "''${pl}" ]]; then
              playerctl -p "''${pl}" previous >/dev/null 2>&1 || true
            fi
            settle=1
            ;;
          11)
            if [[ -n "''${pl}" ]]; then
              playerctl -p "''${pl}" next >/dev/null 2>&1 || true
            fi
            settle=1
            ;;
          12)
            if [[ -n "''${pl}" ]]; then
              playerctl -p "''${pl}" play-pause >/dev/null 2>&1 || true
            fi
            ;;
          13)
            if wpctl set-volume @DEFAULT_SINK@ 5%- >/dev/null 2>&1; then
              pkill -RTMIN+10 i3blocks >/dev/null 2>&1 || true
            fi
            ;;
          14)
            if wpctl set-volume @DEFAULT_SINK@ 5%+ >/dev/null 2>&1; then
              pkill -RTMIN+10 i3blocks >/dev/null 2>&1 || true
            fi
            ;;
        esac

        player_status=""

        if (( settle )); then
          for _ in 1 2 3 4 5 6 7 8 9 10; do
            IFS="''${sep}" read -r player_status _ _ <<<"$(snapshot)"
            if [[ "''${player_status}" == "Playing" ]]; then
              break
            fi
            sleep 0.05
          done
        fi

        IFS="''${sep}" read -r player_status artist title <<<"$(snapshot)"

        # Transient "Paused" right after a skip is just the new track loading:
        # if it played before the skip, keep showing Playing.
        if (( settle )) && [[ "''${pre_status}" == "Playing" && "''${player_status}" != "Playing" ]]; then
          player_status="Playing"
        fi

        if [[ -z "''${artist}" ]]; then
          artist="Unknown artist"
        fi

        if [[ -z "''${title}" ]]; then
          title="Unknown title"
        fi

        case "''${player_status}" in
          Playing)
            status="Playing"
            toggle_icon="''${pause_icon}"
            ;;
          Paused)
            status="Paused"
            toggle_icon="''${play_icon}"
            ;;
          *)
            status="Stopped"
            toggle_icon="''${play_icon}"
            ;;
        esac

        artist=$(truncate_text "''${artist}" 18)
        title=$(truncate_text "''${title}" 30)
        artist=$(escape_markup "''${artist}")
        title=$(escape_markup "''${title}")

        message="<b>''${status}</b>  ''${artist} — ''${title}"

        printf '\0use-hot-keys\x1ftrue\n'
        printf '\0message\x1f%s\n' "''${message}"
        printf '%s\0nonselectable\x1ftrue\n' "''${prev_icon}"
        printf '%s\0nonselectable\x1ftrue\n' "''${toggle_icon}"
        printf '%s\0nonselectable\x1ftrue\n' "''${next_icon}"
      '';
    };
  };

}
