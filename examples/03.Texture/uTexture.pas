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

unit uTexture;

interface

uses
  Spark,
  uCommon;

type
  { TTextureEx }
  TTextureEx = class(TGame)
  protected
  const
    cSpriteWidth   = 128;
    cSpriteHeight  = 128;
    cFrameFirst    = 0;
    cFrameLast     = 2;
    cFrameSpeed    = 14;
    cScaleMin      = 0.5;
    cScaleMax      = 5.0;
    cScaleAmount   = 0.1;
    cStateStr: array[0..6] of string =  ('Draw', 'Alignment', 'Colorkey',
      'Tiled', 'Region', 'Transparency', 'Scale/rotate');
  protected
    FTexture: array[0..10] of TTexture;
    FSpeed: array[0..3] of Single;
    FPos: array[0..3] of TVector;
    FRegion: TRectangle;
    FGridPos: TVector;
    FCenter: TVector;
    FScale: TVector;
    FFrameTimer: Single;
    FFrame: Integer;
    FState: Integer;
  public
    procedure OnSetSettings(var aSettings: TGameSettings); override;
    function  OnStartup: Boolean; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

implementation

{ TTextureEx }
procedure TTextureEx.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'Spark - Texture';
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

function  TTextureEx.OnStartup: Boolean;
begin
  inherited;

  FTexture[0] := TTexture.Create;
  FTexture[0].Load(Archive, 'arc/images/cheetah.jpg', nil);

  FTexture[1] := TTexture.Create;
  FTexture[1].Load(Archive, 'arc/images/square00.png', @COLORKEY);

  FTexture[2] := TTexture.Create;
  FTexture[2].Load(Archive, 'arc/images/circle00.png', nil);
  FTexture[10] := TTexture.Create;
  FTexture[10].Load(Archive, 'arc/images/circle00.png', @COLORKEY);

  FTexture[3] := TTexture.Create;
  FTexture[3].Load(Archive, 'arc/images/space.png', nil);

  FTexture[4] := TTexture.Create;
  FTexture[4].Load(Archive, 'arc/images/nebula.png', @BLACK);

  FTexture[5] := TTexture.Create;
  FTexture[5].Load(Archive, 'arc/images/spacelayer1.png', @BLACK);

  FTexture[6] := TTexture.Create;
  FTexture[6].Load(Archive, 'arc/images/spacelayer2.png', @BLACK);

  FTexture[7] := TTexture.Create;
  FTexture[7].Load(Archive, 'arc/images/boss.png', nil);

  FTexture[8] := TTexture.Create;
  FTexture[8].Load(Archive, 'arc/images/alphacheese.png', nil);

  FTexture[9] := TTexture.Create;
  FTexture[9].Load(Archive, 'arc/images/figure.png', nil);

  // set bitmap speeds
  FSpeed[0] := 0.3 * 30;
  FSpeed[1] := 0.5 * 30;
  FSpeed[2] := 1.0 * 30;
  FSpeed[3] := 2.0 * 30;

  // clear pos
  FPos[0].Clear;
  FPos[1].Clear;
  FPos[2].Clear;
  FPos[3].Clear;

  // texture region
  FCenter.Assign(0.5, 0.5);
  FRegion.Assign(0, 0, cSpriteWidth, cSpriteHeight);
  FFrame := 0;
  FFrameTimer := 0;

  // texture scale/roate
  FScale.W := 1.0;
  FScale.Z := 0.0;

  FState := 0;

  Result := True;
end;

procedure TTextureEx.OnShutdown;
begin
  FreeNilObject(@FTexture[10]);
  FreeNilObject(@FTexture[9]);
  FreeNilObject(@FTexture[8]);
  FreeNilObject(@FTexture[7]);
  FreeNilObject(@FTexture[6]);
  FreeNilObject(@FTexture[5]);
  FreeNilObject(@FTexture[4]);
  FreeNilObject(@FTexture[3]);
  FreeNilObject(@FTexture[2]);
  FreeNilObject(@FTexture[1]);
  FreeNilObject(@FTexture[0]);

  inherited;
end;

procedure TTextureEx.OnUpdate(aDeltaTime: Double);
var
  I: Integer;
begin
  inherited;

  if Game.KeyPressed(KEY_1) then FState := 0;
  if Game.KeyPressed(KEY_2) then FState := 1;
  if Game.KeyPressed(KEY_3) then FState := 2;
  if Game.KeyPressed(KEY_4) then FState := 3;
  if Game.KeyPressed(KEY_5) then FState := 4;
  if Game.KeyPressed(KEY_6) then FState := 5;
  if Game.KeyPressed(KEY_7) then FState := 6;

  case FState of
    0: // texture draw
    begin
    end;

    1: // texture alignment
    begin
    end;

    2: // texture colorkey
    begin
    end;

    3: // texture tiled
    begin
      for I := 0 to 3 do
        FPos[I].Y := FPos[I].Y + (FSpeed[I] * aDeltaTime);
    end;

    4: // texture region
    begin
      // up frame cFrameSpeed times per second
      if FrameSpeed(FFrameTimer, cFrameSpeed) then
      begin
        // increment frame number
        Inc(FFrame);

        // clip frame number between first and last
        Game.ClipValue(FFrame, cFrameFirst, cFrameLast, True);
      end;

      // calc grid x and y based on frame number
      FGridPos.X := (FFrame * cSpriteWidth) mod Round(FTexture[7].Width) / cSpriteWidth;
      FGridPos.Y := floor((FFrame * cSpriteWidth) / FTexture[7].Height);

      // set the x and y position in texture for this frame
      FRegion.X := FGridPos.X * cSpriteWidth;
      FRegion.Y := FGridPos.Y * cSpriteHeight;
    end;

    5: // texture transparency
    begin
    end;

    6: // texture scale/rotate
    begin
      if KeyPressed(KEY_UP) then
        FScale.W := FScale.W + cScaleAmount
      else
      if KeyPressed(KEY_DOWN) then
        FScale.W := FScale.W - cScaleAmount;

      if KeyDown(KEY_LEFT) then
        FScale.Z := FScale.Z - (30.0 * aDeltaTime)
      else
      if KeyDown(KEY_RIGHT) then
        FScale.Z := FScale.Z + (30.0 * aDeltaTime);


      ClipValue(FScale.W, cScaleMin, cScaleMax, False);
      ClipValue(FScale.Z, 0, 359, True);
    end;
  end;
end;

procedure TTextureEx.OnRender;
var
  LCenterPos: TVector;
  LSize: TVector;
  I: Integer;
begin
  inherited;

  case FState of
    0: // texture render
    begin
      FTexture[FState].Draw((Window.Width/2)-(FTexture[FState].Width/2),
        (Window.Height/2)-(FTexture[FState].Height/2), 1, 0, WHITE, haLeft, vaTop);
    end;

    1: // texture alignment
    begin
      LCenterPos.Assign(Settings.WindowWidth/2, Settings.WindowHeight/2);

      Game.DrawLine(LCenterPos.X, 0, LCenterPos.X, Settings.WindowHeight, 1, YELLOW);
      Game.DrawLine(0, LCenterPos.Y, Settings.WindowWidth,  LCenterPos.Y, 1, YELLOW);

      FTexture[FState].Draw(LCenterPos.X, LCenterPos.Y, 1, 0, WHITE, haCenter, vaCenter);
      Font.PrintText(LCenterPos.X, LCenterPos.Y+25, DARKGREEN, haCenter, 'center-center', []);

      Game.DrawLine(0, LCenterPos.Y-128, Settings.WindowWidth,  LCenterPos.Y-128, 1, YELLOW);

      FTexture[FState].Draw(LCenterPos.X, LCenterPos.Y-128, 1, 0, WHITE, haLeft, vaTop);
      Font.PrintText(LCenterPos.X+34, LCenterPos.Y-(128-6), DARKGREEN, haLeft, 'left-top', []);

      FTexture[FState].Draw(LCenterPos.X, LCenterPos.Y-128, 1, 0, WHITE, haLeft, vaBottom);
      Font.PrintText(LCenterPos.X+34, LCenterPos.Y-(128+25), DARKGREEN, haLeft, 'left-bottom', []);

      Game.DrawLine(0, LCenterPos.Y+128, Settings.WindowWidth,  LCenterPos.Y+128, 1, YELLOW);
      FTexture[FState].Draw(LCenterPos.X, LCenterPos.Y+128, 1, 0, WHITE, haRight, vaTop);
      Font.PrintText(LCenterPos.X+4, LCenterPos.Y+(128+6), DARKGREEN, haLeft, 'right-top', []);

      FTexture[FState].Draw(LCenterPos.X, LCenterPos.Y+128, 1, 0, WHITE, haRight, vaBottom);
      Font.PrintText(LCenterPos.X+4, LCenterPos.Y+(128-27), DARKGREEN, haLeft, 'right-bottom', []);
    end;

    2: // texture colorkey
    begin
      LCenterPos.Assign(Settings.WindowWidth/2, Settings.WindowHeight/2);

      LSize.Assign(FTexture[FState].Width, FTexture[FState].Height);

      FTexture[FState].Draw(LCenterPos.X, LCenterPos.Y-LSize.Y, 1.0, 0.0, WHITE, haCenter, vaCenter);
      FTexture[10].Draw(LCenterPos.X, LCenterPos.Y+LSize.Y, 1.0, 0.0, WHITE, haCenter, vaCenter);

      Font.PrintText(LCenterPos.X, LCenterPos.Y-(LSize.Y/2), DARKORANGE, haCenter, 'without colorkey', []);
      Font.PrintText(LCenterPos.X, LCenterPos.Y+(LSize.Y*1.5), DARKORANGE, haCenter, 'with colorkey', []);
    end;

    3: // texture titled
    begin
      for I := 0 to 3 do
      begin
        if I = 1 then SetBlendMode(bmAdditiveAlpha);
        FTexture[I+3].DrawTiled(FPos[I].X, FPos[I].Y);
        if I = 1 then RestoreDefaultBlendMode;
      end;
    end;

    4: // texture region
    begin
      // draw each sprite frame center aligned at the center of the window
      FTexture[7].Draw(Game.Window.Width/2, Game.Window.Height/2, @FRegion, @FCenter, nil, 0, WHITE);
    end;

    5: // texture transparency
    begin
      LSize.Assign(FTexture[8].Width, FTexture[8].Height);
      FTexture[8].Draw(Window.Width/2, Window.Height/2, 1, 0, WHITE, haCenter, vaCenter);
      Font.PrintText(Window.Width/2, (Window.Height/2)+(LSize.Y/3.5), DARKORANGE, haCenter, 'Native transparency', []);
    end;

    6: // texture scale/rotate
    begin
      FTexture[9].Draw(Window.Width/2, Window.Height/2, FScale.W, FScale.Z, WHITE, haCenter, vaCenter);
    end;

  end;
end;

procedure TTextureEx.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN, haLeft, HudTextItem('1-7', 'Texture (#s)'), [cStateStr[FState]]);


  case FState of
    0: // texture render
    begin
    end;

    1: // texture alignment
    begin
    end;

    2: // texture colorkey
    begin
    end;

    3: // texture titled
    begin
    end;

    4: // texture region
    begin
    end;

    5: // texture transparency
    begin
    end;

    6: // texture scale/rotate
    begin
      HudText(Font, GREEN, haLeft, HudTextItem('Up/Down', 'Scale'), []);
      HudText(Font, GREEN, haLeft, HudTextItem('Left/Right', 'Rotate'), []);
      HudText(Font, YELLOW, haLeft, HudTextItem('Scale', '#f'), [FScale.W]);
      HudText(Font, YELLOW, haLeft, HudTextItem('Angle', '#f'), [FScale.Z]);
    end;
  end;
end;

end.
