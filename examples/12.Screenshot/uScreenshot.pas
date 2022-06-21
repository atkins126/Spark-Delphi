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

unit uScreenshot;

interface

uses
  Spark,
  uCommon;

type
  { TScreenshot }
  TScreenshot = class(TGame)
  protected
    FTexture: TTexture;
    FScreenshotImage: TTexture;
    FPos: TVector;
    FFilename: string;
  public
    procedure OnSetSettings(var aSettings: TGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
    procedure OnPreShowWindow; override;
    procedure OnScreenshot(const aFilename: string); override;
  end;

implementation

{ TScreenshot }
procedure TScreenshot.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;

  aSettings.WindowTitle := 'Spark - Screenshot';
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

procedure TScreenshot.OnStartup;
begin
  inherited;

  FScreenshotImage := TTexture.Create;

  FTexture := TTexture.Create;
  FTexture.Load(Archive, 'arc/images/spark2.png', nil);
  FPos.Assign(SGT.Window.Width/2, SGT.Window.Height/2, 30, 0);
end;

procedure TScreenshot.OnShutdown;
begin
  FreeNilObject(FTexture);
  FreeNilObject(FScreenshotImage);

  inherited;
end;

procedure TScreenshot.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // update rotation
  FPos.W := FPos.W + (FPos.Z * aDeltaTime);

  // take a screenshot
  if SGT.Input.KeyPressed(KEY_S) then
    SGT.Screenshot.Take;
end;

procedure TScreenshot.OnRender;
begin
  inherited;

  FTexture.Draw(FPos.X, FPos.Y, 0.65, FPos.W, WHITE, haCenter, vaCenter);
end;

procedure TScreenshot.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN, haLeft, HudTextItem('S', 'Screenshot'), []);
  HudText(Font, YELLOW, haLeft, HudTextItem('File', '#s'), [GetFileName(FFilename)]);
end;

procedure TScreenshot.OnPreShowWindow;
begin
  inherited;

  FScreenshotImage.Draw(SGT.Window.Width-1, 3, 0.25, 0, WHITE, haRight, vaTop);
end;

procedure TScreenshot.OnScreenshot(const aFilename: string);
begin
  inherited;

  // get the filename of last screenshot image
  FFilename := aFilename;

  // load in this image
  FScreenshotImage.Load(nil, FFilename, nil);
end;


end.
