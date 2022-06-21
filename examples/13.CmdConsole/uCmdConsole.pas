{==============================================================================
  ____                   _
 / ___| _ __   __ _ _ __| | __
 \___ \| '_ \ / _` | '__| |/ /
  ___) | |_) | (_| | |  |   <
 |____/| .__/ \__,_|_|  |_|\_\
       |_|   Game Toolkit™

 Copyright © 2022 tinyBigGAMES™ LLC
 All Rights Reserved.

 Website: https://tinybiggames.com
 Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
============================================================================= }

unit uCmdConsole;

interface

uses
  Spark,
  uCommon;

type
  { TCmdConsoleEx }
  TCmdConsoleEx = class(TGame)
  protected
    FStarfield: TStarfield;
    FShowStarfield: Boolean;
  public
    procedure OnSetSettings(var aSettings: TGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure CustCmd1;
    procedure CustCmd2;
  end;

implementation

{ TCmdConsoleEx }
procedure TCmdConsoleEx.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;

  aSettings.WindowTitle := 'Spark - CmdConsole';
  aSettings.WindowClearColor := BLACK;

  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

procedure TCmdConsoleEx.OnStartup;
begin
  inherited;

  FStarfield := TStarfield.Create;
  FShowStarfield := False;

  SGT.CmdConsole.AddCommand('Starfield', 'ON | OFF', CustCmd1);
  SGT.CmdConsole.AddCommand('ClearColor', 'BLACK | DARKSLATEBROWN | SKYBLUE', CustCmd2);
end;

procedure TCmdConsoleEx.OnShutdown;
begin
  FreeNilObject(FStarfield);

  inherited;
end;

procedure TCmdConsoleEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if FShowStarfield then
    FStarfield.Update(aDeltaTime);
end;

procedure TCmdConsoleEx.OnRender;
begin
  inherited;

  if FShowStarfield then
    FStarfield.Render;
end;

procedure TCmdConsoleEx.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN, haLeft, HudTextItem('~', 'Toggle console'), []);
end;

procedure TCmdConsoleEx.CustCmd1;
var
  S,P: string;

  procedure Error;
  begin
    SGT.CmdConsole.AddTextLine('Invalid parameter, usage: starfield on | off', []);
  end;

begin
  s := 'Starfiled ';
  if SGT.CmdConsole.ParamCount < 1 then
  begin
    Error;
    Exit;
  end;

  P := SGT.CmdConsole.ParamStr(0);
  if SameText(P, 'ON') then
    FShowStarfield := True
  else
  if SameText(P, 'OFF') then
    FShowStarfield := False
  else
    begin
      Error;
      Exit;
    end;

  SGT.CmdConsole.AddTextLine(s + P, []);
end;

procedure TCmdConsoleEx.CustCmd2;
var
  S,P: string;

  procedure Error;
  begin
    SGT.CmdConsole.AddTextLine('Invalid parameter, usage: clearcolor BLACK | DARKSLATEBROWN | SKYBLUE', []);
  end;

begin
  s := 'ClearColor ';
  if SGT.CmdConsole.ParamCount < 1 then
  begin
    Error;
    Exit;
  end;

  P := SGT.CmdConsole.ParamStr(0);
  if SameText(P, 'BLACK') then
    FSettings.WindowClearColor := BLACK
  else
  if SameText(P, 'DARKSLATEBROWN') then
    FSettings.WindowClearColor := DARKSLATEBROWN
  else
  if SameText(P, 'SKYBLUE') then
    FSettings.WindowClearColor := SKYBLUE
  else
    begin
      Error;
      Exit;
    end;
  SGT.CmdConsole.AddTextLine(s + P, []);
end;


end.
