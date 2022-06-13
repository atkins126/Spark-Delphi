﻿{==============================================================================
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

unit uTemplate;

interface

uses
  Spark,
  uCommon;

type
  { TTemplate }
  TTemplate = class(TGame)
  protected
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
procedure TTemplate.OnSetSettings(var aSettings: TGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'Spark - Template';
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;
end;

function  TTemplate.OnStartup: Boolean;
begin
  inherited;

  Result := True;
end;

procedure TTemplate.OnShutdown;
begin
  inherited;
end;

procedure TTemplate.OnUpdate(aDeltaTime: Double);
begin
  inherited;
end;

procedure TTemplate.OnFixedUpdate;
begin
  inherited;
end;

procedure TTemplate.OnRender;
begin
  inherited;
end;

procedure TTemplate.OnRenderHUD;
begin
  inherited;
end;

procedure TTemplate.OnReady(aReady: Boolean);
begin
  inherited;
end;

procedure TTemplate.OnVideoState(aState: TVideoState; const aFilename: string);
begin
  inherited;
end;

procedure TTemplate.OnOpenCmdConsole;
begin
  inherited;
end;

procedure TTemplate.OnCloseCmdConsole;
begin
  inherited;
end;

end.
