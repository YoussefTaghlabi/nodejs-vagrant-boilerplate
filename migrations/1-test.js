exports.id = 'test1';

exports.up = function (done) {
    var coll = this.db.collection('contacts');

    coll.insert({
        email: 'contact1@foo.com',
        name: {
          first: 'Contact',
          last: '1'
        },
        phone: '111-111-1111'
    });

    coll.insert({
        email: 'contact2@foo.com',
        name: {
            first: 'Contact',
            last: '2'
        },
        phone: '222-222-2222'
    });

    coll.insert({
        email: 'contact3@foo.com',
        name: {
            first: 'Contact',
            last: '3'
        },
        phone: '333-333-3333'
    });

    done();
};

exports.down = function (done) {
  var coll = this.db.collection('contacts');

  coll.remove({email: 'contact1@foo.com'});
  coll.remove({email: 'contact2@foo.com'});
  coll.remove({email: 'contact3@foo.com'});

  done();
};