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

unit uTestbed;

interface

uses
  Spark,
  uCommon;

type
  { TTestbed }
  TTestbed = class(TGame)
  protected
    FStream: TStream;
    FStarfield: TStarfield;
    FConfigFile: TConfigFile;
  public
    procedure OnSetSettings(var aSettings: TGameSettings); override;
    function  OnStartup: Boolean; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnFixedUpdate; override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure OnReady(aReady: Boolean); override;
    procedure OnVideoState(aState: TVideoState; const aFilename: string); override;
    procedure OnOpenCmdConsole; override;
    procedure OnCloseCmdConsole; override;
    procedure OnScreenshot(const aFilename: string); override;
  end;

implementation

{ TTestbed }
procedure TTestbed.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'Spark - Testbed';
  aSettings.WindowClearColor := BLACK;
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

function  TTestbed.OnStartup: Boolean;
begin
  inherited;
  FConfigFile := TConfigFile.Create;

  FConfigFile.Write('vars', 'ide', 3306);
  FConfigFile.Save('test.cfg');
  FConfigFile.Clear;

  FConfigFile.Load('test.cfg');
  Game.ConsoleWriteLn('ide= #i', [FConfigFile.Read('vars', 'ide', 0)]);

  FreeNilObject(@FConfigFile);


  FStream := TStream.Init('test.stm', True);
  FStream.WriteString('Jarrod Davis');
  FreeNilObject(@FStream);

  FStream := TStream.Init('test.stm', False);
  Game.ConsoleWriteLn(FStream.ReadString, []);
  FreeNilObject(@FStream);

  FStarfield := TStarfield.Create;

  Result := True;
end;

procedure TTestbed.OnShutdown;
begin
  FreeNilObject(@FStarfield);
  inherited;
end;

procedure TTestbed.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if KeyPressed(KEY_S) then StartScreenshake(60, 5);
  if KeyPressed(KEY_D) then TakeScreenshot;


  FStarfield.Update(aDeltaTime);
end;

procedure TTestbed.OnFixedUpdate;
begin
  inherited;
end;

procedure TTestbed.OnRender;
begin
  inherited;

  FStarfield.Render;
end;

procedure TTestbed.OnRenderHUD;
begin
  inherited;
end;

procedure TTestbed.OnReady(aReady: Boolean);
begin
  inherited;
end;

procedure TTestbed.OnVideoState(aState: TVideoState; const aFilename: string);
begin
  inherited;
end;

procedure TTestbed.OnOpenCmdConsole;
begin
  inherited;
end;

procedure TTestbed.OnCloseCmdConsole;
begin
  inherited;
end;

procedure TTestbed.OnScreenshot(const aFilename: string);
begin
  ConsoleWriteLn('Screenshot "#s"', [aFilename]);
end;

end.
