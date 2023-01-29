codeunit 50601 "BackgroundSleep"
{
    trigger OnRun()
    var
        Sleep: Integer;
    begin
        Evaluate(Sleep, Page.GetBackgroundParameters().Get('Sleep'));
        Sleep(Sleep);
    end;
}
