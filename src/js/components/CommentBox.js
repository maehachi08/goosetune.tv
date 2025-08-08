import React from 'react';
import PropTypes from "prop-types";

class CommentBox extends React.Component {
  handleClick() {
  }

  // bootstrap's card-group and semantic-ui card
  render() {

    function CardBlocks(props) {
      const title = props.title;
      const items = props.items;

      // items.path が存在する場合は and more... なリンクを実装すること
      return (
        <div className="container ui segment">
          <h2 className="ui large header">{title}<div className="ui divider"></div></h2>
          <div className="ui six stackable cards column grid" data-masonry='{ "itemSelector": ".grid-item", "columnWidth": 100 }'>
            {items.entry.map((item,i) =>
              <div className="ui card raised grid-item">
                <a className="image" href="#">
                  <img src={item.thumbnail} alt={item.title} />
                </a>
                <div className="content">
                  <a className="header" href="#">{item.title}</a>
                </div>
              </div>
            )}
          </div>
          <p ui meta bottom>and more...</p>
        </div>
      );
    }

    return (
      <div className="container">
        {Object.keys(this.props.items).map((key,i) =>
          <CardBlocks title={key} items={this.props.items[key]} />
        )}
      </div>
    );
  }

  // pure bootstrap card group
  //render() {
  //  function CardBlocks(props) {
  //    const title = props.title;
  //    const items = props.items;
  //    // items.path が存在する場合は and more... なリンクを実装すること
  //    return (
  //      <div className="container masonry">
  //        <h2 className="ui large header">{title}<div className="ui divider"></div></h2>
  //        <div className="card-group grid">
  //          {items.entry.map((item,i) =>
  //            <div className="card">
  //              <img className="card-img-top" src={item.thumbnail} alt={item.title} />
  //              <div className="card-body">
  //                <h5 className="card-title">{item.title}</h5>
  //                <p className="card-text">test</p>
  //                <p className="card-text"><small className="text-muted">1000</small></p>
  //              </div>
  //            </div>
  //          )}
  //        </div>
  //        <p ui meta bottom>and more...</p>
  //      </div>
  //    );
  //  }

  //  return (
  //    <div className="container">
  //      {Object.keys(this.props.items).map((key,i) =>
  //        <CardBlocks title={key} items={this.props.items[key]} />
  //      )}
  //    </div>
  //  );
  //}
}

CommentBox.propTypes = {
  items: PropTypes.object.isRequired,
};

export default CommentBox;
