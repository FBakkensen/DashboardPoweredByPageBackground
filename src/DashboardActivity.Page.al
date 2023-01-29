page 50601 "DashboardActivity"
{
    ApplicationArea = All;
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Activities Cue";
    RefreshOnActivate = true;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            cuegroup("Ongoing Sales")
            {
                Caption = 'Ongoing Sales';
                field("Ongoing Sales Quotes"; Rec."Ongoing Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Quotes';
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies sales quotes that have not yet been converted to invoices or orders.';
                }
                field("Ongoing Sales Orders"; Rec."Ongoing Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Orders';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies sales orders that are not yet posted or only partially posted.';
                }
                field("Ongoing Sales Invoices"; Rec."Ongoing Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Invoices';
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies sales invoices that are not yet posted or only partially posted.';
                }
            }
            group(UpdateTime)
            {
                Caption = 'Last Updated';
                field(LastUpdated; LastUpdated)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    MultiLine = true;
                    Style = StrongAccent;
                }

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        BackgroundUpdate();
    end;

    local procedure BackgroundUpdate()
    var
        TaskParameters: Dictionary of [Text, Text];
    begin
        TaskParameters.Add('Sleep', Format(1000));

        CurrPage.EnqueueBackgroundTask(TaskID, Codeunit::BackgroundSleep, TaskParameters, 2000, PageBackgroundTaskErrorLevel::Error);
    end;

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    begin
        Rec.CalcFields("Ongoing Sales Quotes", "Ongoing Sales Orders", "Ongoing Sales Invoices");

        LastUpdated := Format(CurrentDateTime, 0, 3);
        BackgroundUpdate();
    end;

    var
        TaskID: Integer;
        LastUpdated: Text;
}
