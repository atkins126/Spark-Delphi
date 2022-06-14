{==============================================================================
   ___              __   ___    _
  / __|__ _ _ __  __\ \ / (_)__(_)___ _ _
 | (_ / _` | '  \/ -_) V /| (_-< / _ \ ' \
  \___\__,_|_|_|_\___|\_/ |_/__/_\___/_||_|
                  Toolkit™

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

unit uZipArc;

interface

uses
  Spark;

type

  { TZipArc }
  TZipArc = class
  protected
    FGame: TGame;
    procedure ShowHeader;
    procedure ShowUsage;
    procedure OnProgress(const aFilename: string; aProgress: Integer; aNewFile: Boolean);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Run;
  end;

procedure RunZipArc;

implementation

procedure RunZipArc;
var
  LArc: TZipArc;
begin
  LArc := TZipArc.Create;
  LArc.Run;
  LArc.Free;
end;

{ TGVArc }
procedure TZipArc.ShowHeader;
begin
  if not FGame.ConsolePresent then Exit;
  WriteLn;
  WriteLn('ZipArc™ Archive Utilty v', SPARK_VERSION);
  WriteLn('Copyright © 2022 tinyBigGAMES™');
  WriteLn('All Rights Reserved.');
end;

procedure TZipArc.ShowUsage;
begin
  if not FGame.ConsolePresent then Exit;
  WriteLn;
  WriteLn('Usage: ZipArc [password] archivename[.zip] directoryname');
  WriteLn('  password      - make archive password protected');
  WriteLn('  archivename   - compressed archive name');
  WriteLn('  directoryname - directory to archive');
end;

procedure TZipArc.OnProgress(const aFilename: string; aProgress: Integer; aNewFile: Boolean);
begin
  if not FGame.ConsolePresent then Exit;
  if aNewFile then WriteLn;
  Write(CR+'Adding "', aFilename, '" (', aProgress, '%)...');
end;

constructor TZipArc.Create;
begin
  inherited;
  FGame := TGame.Create;
  FGame.ManualStartup;
end;

destructor TZipArc.Destroy;
begin
  FGame.ManualShutdown;
  FGame.Free;
  inherited;
end;

procedure TZipArc.Run;
var
  LPassword: string;
  LArchiveFilename: string;
  LDirectoryName: string;
  LArchive: TArchive;
  LOk: Boolean;
begin
  // init local vars
  LPassword := '';
  LArchiveFilename := '';
  LDirectoryName := '';

  // display header
  ShowHeader;

  // check for password, archive, directory
  if ParamCount = 3 then
    begin
      LPassword := ParamStr(1);
      LArchiveFilename := ParamStr(2);
      LDirectoryName := ParamStr(3);
      LPassword := FGame.RemoveQuotes(LPassword);
      LArchiveFilename := FGame.RemoveQuotes(LArchiveFilename);
      LDirectoryName := FGame.RemoveQuotes(LDirectoryName);
    end
  // check for archive directory
  else if ParamCount = 2 then
    begin
      LArchiveFilename := ParamStr(1);
      LDirectoryName := ParamStr(2);
      LArchiveFilename := FGame.RemoveQuotes(LArchiveFilename);
      LDirectoryName := FGame.RemoveQuotes(LDirectoryName);
    end
  else
    begin
      // show usage
      ShowUsage;
      Exit;
    end;

  // init archive filename
  //LArchiveFilename :=  TPath.ChangeExtension(LArchiveFilename, 'zip');

  // check if directory exist
  if not FGame.DirExist(LDirectoryName) then
    begin
      if FGame.ConsolePresent then
      begin
        WriteLn;
        WriteLn('Directory was not found: ', LDirectoryName);
      end;
      ShowUsage;
      Exit;
    end;

  // display params
  if FGame.ConsolePresent then
  begin
    WriteLn;
    if LPassword = '' then
      WriteLn('Password : NONE')
    else
      WriteLn('Password : ', LPassword);
    WriteLn('Archive  : ', LArchiveFilename);
    WriteLn('Directory: ', LDirectoryName);
  end;

  // try to build archive
  LArchive := TArchive.Create;
  LOk := LArchive.Build(LPassword, LArchiveFilename, LDirectoryName, OnProgress);
  if FGame.ConsolePresent then
  begin
    if LOk then
      WriteLn(LF+'Success!')
    else
      WriteLn(LF+'Failed!');
  end;
  LArchive.Free;
end;

end.
