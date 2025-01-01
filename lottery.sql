UPDATE
    `lottery_names`
SET
    `status` = '0',
    `win_date` = NULL;
DELETE
FROM
    `winners`;
ALTER TABLE
    `winners` MODIFY `id` INT NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 0;