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

unit uVideo;

interface

uses
  Spark,
  uCommon;

type
  { TVideoEx }
  TVideoEx = class(TGame)
  protected
    FFilename: array[0..2] of string;
    FNum: Integer;
    procedure Play(aNum: Integer; aVolume: Single);
  public
    procedure OnSetSettings(var aSettings: TGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure OnVideoState(aState: TVideoState; aFilename: string); override;

  end;

implementation

{ TVideoEx }
procedure TVideoEx.Play(aNum: Integer; aVolume: Single);
begin
  if (aNum < Low(FFilename)) or (aNum > High(FFilename)) then Exit;
  if  (aNum = FNum) then Exit;
  FNum := aNum;
  SGT.Video.Play(Archive, 'arc/videos/'+FFilename[FNum], True, aVolume);
end;

procedure TVideoEx.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;

  aSettings.WindowTitle := 'Spark - Video';
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

procedure TVideoEx.OnStartup;
begin
  inherited;

  FFilename[0] := 'tinyBigGAMES.ogv';
  FFilename[1] := 'spark1.ogv';
  FFilename[2] := 'spark2.ogv';
  FNum := -1;
  Play(0, 1);
end;

procedure TVideoEx.OnShutdown;
begin
  SGT.Video.Unload;

  inherited;
end;

procedure TVideoEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if SGT.Input.KeyPressed(KEY_1) then Play(0, 0.5)
  else
  if SGT.Input.KeyPressed(KEY_2) then Play(1, 0.5)
  else
  if SGT.Input.KeyPressed(KEY_3) then Play(2, 0.5);

end;

procedure TVideoEx.OnRender;
begin
  inherited;

  SGT.Video.Draw(0, 0, 0.50);
end;

procedure TVideoEx.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN, haLeft, HudTextItem('1-3', 'Video (#s)'), [FFilename[FNum]]);
end;

procedure TVideoEx.OnVideoState(aState: TVideoState; aFilename: string);
begin
  inherited;

  case aState of
    vsLoad    : PrintLn('Load video: #s', [aFilename]);
    vsUnload  : PrintLn('Unload video: #s', [aFilename]);
    vsPlaying : PrintLn('Playing video: #s', [aFilename]);
    vsPaused  : PrintLn('Paused video: #s', [aFilename]);
    vsFinished: PrintLn('Finished video: #s', [aFilename]);
  end;
end;

end.
