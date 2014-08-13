? extends 'common/base';
? extends 'common/jobs_base';

? block content => sub {
<div id="jobs">
? for my $category ($c->stash->{categories}->all) {
    <div class="category_<?= lc $category->name ?>">
      <div class="category">
        <div class="feed">
            <a href="">Feed</a>
        </div>
<!-- some HTML code -->
        <h1>
          <a href="<?= $c->uri_for('/category', $category->slug) ?>">
            <?= $category->name ?>
          </a>
        </h1>
<!-- some HTML code -->
      </div>

? my $max_rows = $c->config->{max_jobs_on_homepage};
?= include('job/partial/jobs', $category->get_active_jobs({ rows => $max_rows }));

<!-- some HTML code -->
? my $count = $category->get_active_jobs->count;
? if ( (my $rest = $count - $max_rows) > 0 ) {
      <div class="more_jobs">
        and <a href="<?= $c->uri_for('/category', $category->slug) ?>"><?= $rest ?></a>
        more...
      </div>
? } # endif
<!-- some HTML code -->
    </div>
? } #endfor $category
</div>
? } #endblock content