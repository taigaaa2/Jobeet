use Test::More;
use CGI::Simple;

use_ok 'Jobeet::Form::Job';

{
    my $f = Jobeet::Form::Job->new(
        CGI::Simple->new({
            company      => 'Sensio Labs',
            position     => 'Developer',
            location     => 'Atlanta, USA',
            email        => 'not.an.email',
        }),
    );

    ok $f->has_error, 'form has error ok';

    like $f->error_message_plain('description'),
        qr/required/, 'description required ok';
    like $f->error_message_plain('how_to_apply'),
        qr/required/, 'how_to_apply required ok';
    like $f->error_message_plain('email'),
        qr/invalid/, 'email is invalid ok';
}

done_testing;
