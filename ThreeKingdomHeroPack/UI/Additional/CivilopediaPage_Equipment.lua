-- ===========================================================================
--	Civilopedia - Great Person Page Layout
-- ===========================================================================
include("GameEffectsText")

PageLayouts["Equipment"] = function(page)
    local sectionId = page.SectionId;
    local pageId = page.PageId;

    SetPageHeader(page.Title);
    SetPageSubHeader(page.Subtitle);

    local equipment = GameInfo.TKH_Equipments[pageId];
    -- Right column data
    if (equipment) then
        AddPortrait(equipment.Icon);
    end

	-- Equipment Description
	AddChapter("LOC_UI_PEDIA_DESCRIPTION", string.gsub(Locale.Lookup(equipment.Description), Locale.Lookup(equipment.Name)..'：', ''));

    local chapters = GetPageChapters(page.PageLayoutId);
    if (chapters) then
        for i, chapter in ipairs(chapters) do
            local chapterId = chapter.ChapterId;
            local chapter_header = GetChapterHeader(sectionId, pageId, chapterId);
            local chapter_body = GetChapterBody(sectionId, pageId, chapterId);

            AddChapter(chapter_header, chapter_body);
        end
    end

end
