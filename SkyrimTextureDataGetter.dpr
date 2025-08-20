program SkyrimTextureDataGetter;

{$APPTYPE CONSOLE}

{$R *.res}

uses
	System.SysUtils,
	System.IOUtils,
	System.Classes,
	System.Types,
	System.Generics.Collections;

var
  strAppFolder: string;
  tstrlistDDSFiles, tstrlistDDSResolutions: TStringList;
  filestreamCurrent: TFileStream;
  iHeight, iWidth: DWORD; // iHeight @ +12/0C, iWidth @ +16/10
  iCounter: integer;
  strarrayFiles: TArray<string>;

begin

	strAppFolder := GetCurrentDir + '\';
    WriteLn(strAppFolder);

	tstrlistDDSFiles := TStringList.Create;
	tstrlistDDSResolutions := TStringList.Create;

    WriteLn(strAppFolder);

    try

        WriteLn('Starting code!');

        strarrayFiles := TDirectory.GetFiles(strAppFolder, '*.dds', TSearchOption.soAllDirectories);

		tstrlistDDSFiles.AddStrings(strarrayFiles);

        for iCounter := 0 to tstrlistDDSFiles.Count - 1 do begin

          filestreamCurrent := TFileStream.Create(tstrlistDDSFiles[iCounter], fmOpenRead or fmShareDenyWrite);
          try

              filestreamCurrent.Seek($0C, soFromBeginning);
              filestreamCurrent.ReadBuffer(iHeight, 4);

              filestreamCurrent.Seek($10, soFromBeginning);
              filestreamCurrent.ReadBuffer(iWidth, 4);

              tstrlistDDSResolutions.Add(IntToStr(iWidth) + '_' +IntToStr(iHeight));

              WriteLn(tstrlistDDSResolutions[iCounter]);

          finally

            filestreamCurrent.Free;

          end;

        end;

    except

        on E: Exception do
            Writeln(E.ClassName, ': ', E.Message);

    end;

    tstrlistDDSFiles.SaveToFile(strAppFolder + 'DDSFiles.txt');
    tstrlistDDSResolutions.SaveToFile(strAppFolder + 'DDSFilesResolutions.txt');

	tstrlistDDSFiles.Free;
	tstrlistDDSResolutions.Free;

    ReadLn;

end.

