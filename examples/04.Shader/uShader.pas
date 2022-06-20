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

unit uShader;

interface

uses
  Spark,
  uCommon;

type
  { TShaderEx }
  TShaderEx = class(TGame)
  protected
  const
    CName: array[0..2] of string = ('swirl', 'vortex', 'fire');
  protected
    FShader: array[0..2] of TShader;
    FIndex: Integer;
  public
    procedure OnSetSettings(var aSettings: TGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderHUD; override;
  end;

implementation

{ TShaderEx }
procedure TShaderEx.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;

  aSettings.WindowTitle := 'Spark - Shader';
  aSettings.WindowClearColor := BLACK;
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

procedure TShaderEx.OnStartup;
var
  I: Integer;
begin
  inherited;

  for I := 0 to 2 do
  begin
    FShader[I] := TShader.Create;
    FShader[I].Load(Archive, stFragment, FormatStr('arc/shaders/#s.frag', [CName[I]]));
    FShader[I].Build;

    FShader[I].Enable(True);
    FShader[I].SetVec2Uniform('u_resolution', SGT.Window.Width * SGT.Window.Scale, SGT.Window.Height * SGT.Window.Scale);
    FShader[I].Enable(False);
  end;

  FIndex := 0;
end;

procedure TShaderEx.OnShutdown;
var
  I: Integer;
begin
  for I := 2 downto 0 do
    FreeNilObject(FShader[I]);

  inherited;
end;

procedure TShaderEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if SGT.Input.KeyPressed(KEY_1) then
    FIndex := 0
  else
  if SGT.Input.KeyPressed(KEY_2) then
    FIndex := 1
  else
  if SGT.Input.KeyPressed(KEY_3) then
    FIndex := 2;

  FShader[FIndex].Enable(True);
  FShader[FIndex].SetFloatUniform('u_time', GetTime);
  FShader[FIndex].Enable(False);
end;

procedure TShaderEx.OnRender;
begin
  inherited;

  FShader[FIndex].Enable(True);
  SGT.Window.DrawFilledRectangle(0, 0, SGT.Window.Width, SGT.Window.Height, WHITE);
  FShader[FIndex].Enable(False);
end;

procedure TShaderEx.OnRenderHUD;
begin
  inherited;

  HudText(FFont, GREEN, haLeft, HudTextItem('1-3', 'Shader (#s)'), [CName[FIndex]]);
end;

end.
