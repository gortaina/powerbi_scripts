// Unzip files compressed with 7z,
//7z a -tzip archive.zip @listfile.txt -scsUTF-8 -sccUTF-8 -spf
//The good value for encodeFormat is 850 (DOS/WINDOWS) or UTF-8
//credits to artemus https://community.powerbi.com/t5/Power-Query/How-to-connect-Azure-DevOps-REST-API-in-to-power-bi/td-p/895217
(ZIPFile, encodeFormat) => 
let
    ushort = BinaryFormat.ByteOrder(BinaryFormat.UnsignedInteger16, ByteOrder.LittleEndian),
    uint = BinaryFormat.ByteOrder(BinaryFormat.UnsignedInteger32, ByteOrder.LittleEndian),
    EDOCfn = BinaryFormat.Record([
        ZipContent = BinaryFormat.Binary(Binary.Length(ZIPFile) - 22),
        Magic = uint,
        DiskNum = ushort,
        CDirectoryDiskId = ushort,
        CDirectoryRecordCountOnDisk = ushort,
        CDirectoryRecordCount = ushort,
        SizeOfCentralDirectory = uint,
        CentralDirectoryOffset = uint,
        CommendLength = ushort
    ]),
    EDOC = EDOCfn(ZIPFile),
    BeforeCentralDirectory = BinaryFormat.Binary(EDOC[CentralDirectoryOffset]),
    CentralDirectory = BinaryFormat.Length(BinaryFormat.Record(
        [
            ZipContent = BeforeCentralDirectory,
            Items = BinaryFormat.List(BinaryFormat.Record(
                [
                    Magic = uint,
                    CurrentVersion = ushort,
                    MinVersion = ushort,
                    Flags = ushort,
                    CompressionMethod = ushort,
                    FileModificationTime = ushort,
                    FileModificationDate = ushort,
                    CRC32 = uint,
                    BinarySize = uint,
                    FileSize   = uint,
                    FileInfo = BinaryFormat.Choice(
                    BinaryFormat.Record(
                        [
                            Len = ushort,
                            FieldsLen = ushort,
                            FileCommentLength = ushort,
                            Disk = ushort,
                            InternalFileAttr = ushort,
                            ExternalAttr = uint,
                            PosOfFileHeader = uint
                        ]),
                    (fileInfo) => BinaryFormat.Record(
                        [
                            FileName = BinaryFormat.Text(fileInfo[Len], encodeFormat),
                            Fields = BinaryFormat.Binary(fileInfo[FieldsLen]),
                            FileComment = BinaryFormat.Text(fileInfo[FileCommentLength], encodeFormat),
                            Disk = BinaryFormat.Transform(BinaryFormat.Null, each fileInfo[Disk]),
                            InternalFileAttr = BinaryFormat.Transform(BinaryFormat.Null, each fileInfo[Disk]),
                            ExternalAttr = BinaryFormat.Transform(BinaryFormat.Null, each fileInfo[InternalFileAttr]),
                            PosOfFileHeader = BinaryFormat.Transform(BinaryFormat.Null, each fileInfo[PosOfFileHeader])
                        ])
                    )
                ]), 
                EDOC[CDirectoryRecordCount]
            )
        ]), 
        EDOC[CentralDirectoryOffset] + EDOC[SizeOfCentralDirectory]),  
    Contents = List.Transform(
        CentralDirectory(ZIPFile)[Items],
            (cdEntry) => 
                let
                    ZipEntry = BinaryFormat.Record(
                    [
                        PreviousData = BinaryFormat.Binary(cdEntry[FileInfo][PosOfFileHeader]), 
                        Magic = uint,
                        ZipVersion = ushort,
                        ZipFlags = ushort,
                        CompressionMethod = ushort,
                        FileModificationTime = ushort,
                        FileModificationDate = ushort,
                        CRC32 = uint, 
                        BinarySize = uint,
                        FileSize   = uint,
                        FileName = BinaryFormat.Choice(
                            BinaryFormat.Record(
                                [
                                    Len = ushort,
                                    FieldsLen = ushort
                                ]),
                            (fileInfo) => BinaryFormat.Record(
                                [
                                    FileName = BinaryFormat.Text(fileInfo[Len], encodeFormat),
                                    Fields = BinaryFormat.Binary(fileInfo[FieldsLen])
                                ]) 
                        ),
                        FileContent = BinaryFormat.Transform(
                            BinaryFormat.Binary(cdEntry[BinarySize]), 
                            each Binary.Decompress(_, Compression.Deflate)
                        )
                    ])(ZIPFile)
                in
                    [FileName=ZipEntry[FileName][FileName], Content=ZipEntry[FileContent]]
    )
in
    Contents
