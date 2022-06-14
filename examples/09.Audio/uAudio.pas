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

unit uAudio;

interface

uses
  Spark,
  uCommon;

type
  { TTemplate }
  TAudioExample = class(TGame)
  protected
    FFilename: string;
    FNum: Integer;
    FSample: array[ 0..8 ] of TSample;
    FSampleId: TSampleId;
    procedure Play(aNum: Integer; aVol: Single);
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
  end;

implementation

{ TTemplate }
procedure TAudioExample.Play(aNum: Integer; aVol: Single);
begin
  if aNum < 10 then
    FFilename := FormatStr('arc/music/song0#i.ogg', [aNum])
  else
    FFilename := FormatStr('arc/music/song#i.ogg', [aNum]);
  PlayMusic(Archive, FFilename, aVol, True);
end;

procedure TAudioExample.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'Spark - Audio';
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

function  TAudioExample.OnStartup: Boolean;
var
  I: Integer;
begin
  inherited;

  for I := 0 to 5 do FSample[I] := LoadSample(Archive, FormatStr('arc/sfx/samp#i.ogg', [I]));
  FSample[6] := LoadSample(Archive, 'arc/sfx/weapon_player.ogg');
  FSample[7] := LoadSample(Archive, 'arc/sfx/thunder.ogg');
  FSample[8] := LoadSample(Archive, 'arc/sfx/digthis.ogg');

  FNum := 1;
  FFilename := '';
  Play(1, 1.0);

  Result := True;
end;

procedure TAudioExample.OnShutdown;
var
  I: Integer;
begin
  StopAllSamples;
  for I := 0 to 5 do UnLoadSample(FSample[i]);
  UnLoadSample(FSample[6]);
  UnLoadSample(FSample[7]);
  UnLoadSample(FSample[8]);

  UnloadMusic;
  inherited;
end;

procedure TAudioExample.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if KeyPressed(KEY_UP) then
  begin
    Inc(FNum);
    if FNum > 13 then
      FNum := 1;
    Play(FNum, 1.0);
  end
  else
  if KeyPressed(KEY_DOWN) then
  begin
    Dec(FNum);
    if FNum < 1 then
      FNum := 13;
    Play(FNum, 1.0);
  end;

  if KeyPressed(KEY_1) then
    PlaySample(FSample[0], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_2) then
    PlaySample(FSample[1], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_3) then
    PlaySample(FSample[2], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_4) then
    PlaySample(FSample[3], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_5) then
    PlaySample(FSample[4], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_6) then
  begin
    if not GetSamplePlaying(FSampleId) then
      PlaySample(FSample[5], 1, AUDIO_PAN_NONE,  1, True, @FSampleId);
  end;

  if KeyPressed(KEY_7) then
  begin
      PlaySample(FSample[6], 1, AUDIO_PAN_NONE,  1, False, nil);
  end;

  if KeyPressed(KEY_8) then
    PlaySample(FSample[7], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_9) then
    PlaySample(FSample[8], 1, AUDIO_PAN_NONE,  1, False, nil);

  if KeyPressed(KEY_0) then
  begin
    if GetSamplePlaying(FSampleId) then
      StopSample(FSampleId);

  end;

end;

procedure TAudioExample.OnFixedUpdate;
begin
  inherited;
end;

procedure TAudioExample.OnRender;
begin
  inherited;
end;

procedure TAudioExample.OnRenderHUD;
begin
  inherited;
  HudText(Font, GREEN,  haLeft, HudTextItem('Up/Down', 'Play sample'), []);
  HudText(Font, GREEN, haLeft, HudTextItem('1-9', 'Play sample'), []);
  HudText(Font, GREEN, haLeft, HudTextItem('0', 'Stop looping sample'), []);
  HudText(Font, ORANGE, haLeft, HudTextItem('Song:', '#s', ' '), [GetFileName(FFilename)]);
end;

procedure TAudioExample.OnReady(aReady: Boolean);
begin
  inherited;
end;

procedure TAudioExample.OnVideoState(aState: TVideoState; const aFilename: string);
begin
  inherited;
end;

procedure TAudioExample.OnOpenCmdConsole;
begin
  inherited;
end;

procedure TAudioExample.OnCloseCmdConsole;
begin
  inherited;
end;

end.
