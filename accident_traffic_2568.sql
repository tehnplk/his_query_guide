-- ============================================================
-- รายงานอุบัติเหตุทางการจราจร ปีงบประมาณ 2568
-- (1 ต.ค. 2567 - 30 ก.ย. 2568)
-- ฐานข้อมูล: HOSxP (MySQL)
-- ============================================================
-- ICD-10 หมวด V (V01-V99) = Transport Accidents
-- Triage จากตาราง er_emergency_level (5 ระดับ ESI)
-- ============================================================

SELECT
    (SELECT hospitalcode FROM opdconfig LIMIT 1)    AS hoscode,
    DATE_FORMAT(v.vstdate, '%Y-%m-%d')              AS dateserv,
    CONCAT(p.pname, p.fname, ' ', p.lname)          AS patient_name,
    CASE p.sex
        WHEN '1' THEN 'ชาย'
        WHEN '2' THEN 'หญิง'
        ELSE '-'
    END                                             AS sex,
    TIMESTAMPDIFF(YEAR, p.birthday, v.vstdate)      AS age,
    d.icd10,
    i.name                                          AS icd_name,
    IFNULL(el.er_emergency_level_name, '-')         AS triage
FROM ovst v
    JOIN patient p          ON p.hn  = v.hn
    JOIN ovstdiag d         ON d.vn  = v.vn
    JOIN icd101 i           ON i.code = d.icd10
    LEFT JOIN er_regist er  ON er.vn = v.vn
    LEFT JOIN er_emergency_level el
        ON el.er_emergency_level_id = er.er_emergency_level_id
WHERE d.icd10 LIKE 'V%'
    AND v.vstdate BETWEEN '2025-10-01' AND '2026-09-30'
ORDER BY v.vstdate;
