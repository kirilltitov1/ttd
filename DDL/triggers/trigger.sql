
drop function if exists validateTextReview cascade;
create function validateTextReview () returns trigger AS
    $$
        begin
            if (NEW.text is not null) then
                if (NEW.text like '%abuse%') then
                    return null;
                else
                    return new;
                end if;
            else
                raise '';
            end if;
        end;
    $$ LANGUAGE  plpgsql;
create trigger insertReviews
    before insert on reviews for each row
    execute procedure validateTextReview ()

