% debian 05jed-common.sl              -*- slang -*-

% make delete key delete the character under the cursor
% (section 9.8 of the Debian Policy)
#ifdef XWINDOWS
x_set_keysym (0xFFFF, 0, "\e[3~");
#endif
setkey ("delete_char_cmd", "\e[3~");

% Fallback emulation (if the user has no ~/.jedrc config file)
%
% Possible values are "brief", "cua", "emacs", "edt", "ide", "jed",
% "wordstar", and (with jed-extra) "vi".
%_Jed_Default_Emulation = "emacs";  % already set in site.sl

% Override (obsolete) code in site.sl that calls JED_ROOT/lib/jed.rc as
% fallback configuration file
Default_Jedrc_Startup_File = NULL; % eventually overwritten below

% Jed_Home_Directory (defined in site.sl, defaulting to $HOME)
%
% If a subdir ~/.jed/ exists, point Jed_Home_Directory there,
% so .jedrc and .jedrecent are not spoiling the $HOME dir (FHS 2.3)
$1 = path_concat(Jed_Home_Directory, ".jed");
if ( 2 == file_status($1) ) {
   % Adapt the user config file path:
   % a) command_line_hook() in site.sl tries with ~/.jed/.jedrc
   % b) recommended location: ~/.jed/jed.rc
   % c) backwards compatible: ~/.jedrc
   foreach $2 ([path_concat(Jed_Home_Directory, ".jed/jed.rc"), 
		path_concat(Jed_Home_Directory, ".jedrc")]) {
      if (file_status($2) == 1) {
	 Default_Jedrc_Startup_File = $2;
	 break;
      }
   }
   % now set the variable:
   Jed_Home_Directory = $1;
}

% do not call info_mode() for *.info files
% (as info_mode is no editing mode but an info reader mode!)
add_mode_for_extension("no", "info");
