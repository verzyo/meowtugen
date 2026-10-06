{dms}: {
  pkgs,
  lib,
  config,
  ...
}: let
  root = ./..;

  cfg = config.programs.meowtugen;
  configHome = config.xdg.configHome;
in {
  options.programs.meowtugen = {
    enable = lib.mkEnableOption "meowtugen matugen templates";

    autoEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable all meowtugen app templates by default. Set to false to opt in per app instead.";
    };

    package = lib.mkPackageOption pkgs "matugen" {};

    zed.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.autoEnable;
      defaultText = lib.literalExpression "config.programs.meowtugen.autoEnable";
      description = "Whether to enable the Zed editor template.";
    };

    foot.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.autoEnable;
      defaultText = lib.literalExpression "config.programs.meowtugen.autoEnable";
      description = "Whether to enable the foot terminal template.";
    };

    niri.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.autoEnable;
      defaultText = lib.literalExpression "config.programs.meowtugen.autoEnable";
      description = "Whether to enable the niri wm template.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."matugen/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
      config = {};

      templates = let
        dmsTemplates = "${dms}/quickshell/matugen/templates";
      in
        lib.optionalAttrs cfg.zed.enable {
          zed = {
            input_path = "${root}/templates/zed.json";
            output_path = "${configHome}/zed/themes/meowtugen.json";
          };
        }
        // lib.optionalAttrs cfg.foot.enable {
          foot_colors.input_path = "${root}/templates/foot/colors.ini";

          foot_reload = {
            input_path = "${root}/templates/foot/reload.sh";
            output_path = "${configHome}/foot/reload.sh";
            post_hook = "sh ${configHome}/foot/reload.sh";
          };

          foot = {
            input_path = "${root}/templates/foot/foot.ini";
            output_path = "${configHome}/foot/colors.ini";
          };
        }
        // lib.optionalAttrs cfg.niri.enable {
          niri = {
            input_path = "${dmsTemplates}/niri-colors.kdl";
            output_path = "${configHome}/niri/colors.kdl";
          };
        };
    };
  };
}
